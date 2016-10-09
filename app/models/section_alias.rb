class SectionAlias < ApplicationRecord
  belongs_to :section
  belongs_to :insurer

  validates :name, presence: true, uniqueness: {scope: :insurer_id}
end
