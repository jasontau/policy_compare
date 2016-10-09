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

  def limit_for( wording_alias )
    coverages.find_by_name
  end
end
