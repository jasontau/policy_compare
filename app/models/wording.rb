class Wording < ApplicationRecord
  belongs_to :insurer
  belongs_to :wording_alias
  has_many :coverages, dependent: :destroy
  has_many :quotes, through: :coverages

  validates :name, presence: true, uniqueness: { scope: :insurer }
end
