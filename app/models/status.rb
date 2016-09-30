class Status < ApplicationRecord
  has_many :accounts, dependent: :nullify

  validates :name, uniqueness: true
end
