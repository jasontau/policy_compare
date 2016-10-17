class User < ApplicationRecord
  has_many :accounts, dependent: :nullify

  has_secure_password

  after_initialize :set_defaults

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false},
                    format: VALID_EMAIL_REGEX

  def accounts_that_are string
    accounts.where("status_id = ?", Status.find_by_name(string)).count
  end

  def accounts_that_are_open
    accounts.where("status_id = ? OR status_id = ?", Status.find_by_name("Open"), Status.find_by_name("New"))
  end

  def accounts_within num_days
    accounts_that_are_open
                .where("effective_date > ? AND effective_date < ?", DateTime.now, DateTime.now + num_days.days)
                .order(:effective_date)
  end

  def accounts_for_next_month
    d = accounts_that_are_open
                .where("effective_date > ? AND effective_date < ?", DateTime.now, DateTime.now + 30.days)
                .order(:effective_date)

    results = {}
    30.times do |i|
      results[i.to_s] = 0
    end

    d.each do |record|
      results[seconds_to_units(record.effective_date - Time.now)] ||= 0
      results[seconds_to_units(record.effective_date - Time.now)] += 1
    end
    results
  end

  def seconds_to_units(seconds)
    '%d' %
      # the .reverse lets us put the larger units first for readability
      [24,60,60].reverse.inject([seconds]) {|result, unitsize|
        result[0,0] = result.shift.divmod(unitsize)
        result
      }
  end

  # get random sampling for now
  def user_events
    a = accounts.order("RANDOM()").limit(10).where("status_id = ? OR status_id = ?", 1, 3)
    result = []
    a.each do |record|
      if record.status_id == 3
        result << ["Bound", Customer.find(record.customer_id).name, record.quotes.order("RANDOM()").first.premium]
      else
        result << ["New", Customer.find(record.customer_id).name, record.effective_date]
      end
    end
    result
  end

  private
  def set_defaults # double up defaulting admin to false
    self.admin ||= false
  end
end
