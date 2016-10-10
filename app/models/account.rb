class Account < ApplicationRecord
  belongs_to :customer
  belongs_to :sic
  belongs_to :status

  scope :status, -> (status) { where status: status }
  scope :user_id, -> (user_id) { where user_id: user_id }

  has_many :quotes, dependent: :nullify

  # TODO: Not this... don't do this... fix please
  def quote_info
    result = {}
    quotes.each do |quote|
      result[quote.policy] = {}
      quote.coverages.each do |coverage|
        if coverage.wording.wording_alias
          result[quote.policy][coverage.wording.wording_alias.name] = {
            limit:coverage.limit,
            deductible:coverage.deductible,
            deductible_percent:coverage.deductible_percent }
        end
      end
    end
    result
  end
end
