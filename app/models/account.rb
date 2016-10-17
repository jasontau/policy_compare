class Account < ApplicationRecord
  belongs_to :customer
  belongs_to :sic
  belongs_to :status
  belongs_to :user

  scope :status, -> (status) { where status: status }
  scope :user_id, -> (user_id) { where user_id: user_id }

  has_many :quotes, dependent: :destroy

  # TODO: Not this... don't do this... fix please
  def quote_info
    result = {}
    tiv = 0

    quotes.each do |quote|
      result[quote.policy] = {}
      quote.coverages.each do |coverage|
        wording = coverage.wording.wording_alias
        if wording
          #TODO: Remove special case wording interpretations
          if wording.name == "Building" || wording.name == "Contents"
            result[quote.policy]["TIV"] ||= 0
            result[quote.policy]["TIV"] += coverage.limit if coverage.limit
          end
          if wording.name == "ALS"
            result[quote.policy]["Profits"] = {
              limit: "ALS",
              deductible: coverage.deductible }
          else
            result[quote.policy][wording.name] = {
              limit:coverage.limit,
              deductible:coverage.deductible,
              deductible_percent:coverage.deductible_percent }
            end
        end
      end
    end

    result["TIV"] = tiv
    result
  end

  def get_normalized_quotes
    result = {}
    quotes.each do |quote|
      result[quote.policy] = get_wording_template
      result[quote.policy]["TIV"] = 0
      result[quote.policy].each do |name, hash|
        c = quote.get_coverage_by_alias(name)
        if c then
          result[quote.policy][name][:limit] = c.limit if c.limit
          result[quote.policy][name][:deductible] = c.deductible if c.deductible
          result[quote.policy][name][:deductible_percent] = c.deductible_percent if c.deductible_percent
          if name == "Building" || name == "Contents"
            result[quote.policy]["TIV"] += c.limit if c.limit
          end
        end
      end
    end
    result
  end

  def get_prioritized_quotes
    result = get_normalized_quotes
    # extract each quote
    compare = []
    result.each do |quote, coverages|
      compare << coverages
    end

    # compare each coverage based on limit and insert a key
    indexes = get_wording_template
    indexes.each do |name, value|
      coverage_limits = []
      compare.each do |quote|
        coverage_limits << (quote[name][:limit].nil? ? 0 : quote[name][:limit])
      end
      max = get_max coverage_limits
      compare[max][name][:best] = true if max
    end

    # put the results back...
    i = 0
    result.each do |key, _|
      result[key] = compare[i]
      i += 1
    end

    result
  end

  def get_max(array)
    result = nil
    max = array[0]
    array.count.times do |count|
      if !result && array[count] != max
        result = 0
      end
      if array[count] > max
        max = array[count]
        result = count
      end
    end
    result
  end

  def get_wording_template
    wordings = {}
    get_wording_aliases.each do |wording|
      wordings[wording.name] = {}
    end
    wordings
  end

  def self.average_quote_per_day_for sic_code
    self.joins(:quotes)
      .group(:sic_id)
      .group_by_week(:effective_date, range: 1.month.ago..1.month.from_now)
      .where("sic_id = ?", Sic.find_by_code(sic_code))
      .average(:premium)
  end

  def self.quote_success_rate
    a = self.joins(:quotes).group(:status_id).count
    result = []
    a.each do |record|
      record[0] = Status.find(record[0]).name; result << record
    end
    result
  end

  private
  def get_wording_aliases
    WordingAlias.all
  end
end
