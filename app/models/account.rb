class Account < ApplicationRecord
  belongs_to :customer
  belongs_to :sic
  belongs_to :status

  has_many :quotes, dependent: :nullify
end
