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

  private
  def set_defaults # double up defaulting admin to false
    self.admin ||= false
  end
end
