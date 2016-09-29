class Sic < ApplicationRecord
  has_many :accounts, dependent: :nullify

  validates :code, presence: true, uniqueness: true
end
