class Customer < ApplicationRecord
  validates :name, uniqueness: {scope: :address}
  validates :address, presence: true
end
