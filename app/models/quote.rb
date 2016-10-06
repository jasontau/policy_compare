class Quote < ApplicationRecord
  include Policy

  belongs_to :insurer
  belongs_to :account
  has_many :coverages, dependent: :destroy
  has_many :wordings, through: :coverages

  mount_uploader :pdf, QuoteUploader
  mount_uploader :csv, QuoteCsvUploader

  validates :policy, presence: true
  validates :account, presence: true

end
