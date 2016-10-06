class Insurer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :am_best_rating, presence: true

  has_many :wordings, dependent: :destroy
  has_many :section_aliases, dependent: :destroy
  has_many :quotes, dependent: :nullify
end
