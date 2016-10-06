class Coverage < ApplicationRecord
  belongs_to :quote
  belongs_to :wording

  validates :wording_id, uniqueness: {scope: :quote_id}
end
