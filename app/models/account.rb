class Account < ApplicationRecord
  belongs_to :customer
  belongs_to :sic
  belongs_to :status
end
