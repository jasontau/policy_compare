class Insurer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :am_best_rating, presence: true
end
