class Customer < ApplicationRecord
  has_many :accounts, dependent: :nullify

  validates :name, uniqueness: {scope: :address}
  validates :address, presence: true
end
