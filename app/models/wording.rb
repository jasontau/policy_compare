class Wording < ApplicationRecord
  belongs_to :insurer

  validates :name, presence: true, uniqueness: { scope: :insurer }
  validates :name,
end
