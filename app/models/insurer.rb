class Insurer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :am_best_rating, presence: true

  has_many :wordings
  has_many :section_aliases
end
