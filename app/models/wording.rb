class Wording < ApplicationRecord
  belongs_to :insurer
  has_many :coverages, dependent: :destroy
  has_many :quotes, through: :coverages

  validates :name, presence: true, uniqueness: { scope: :insurer }
end
