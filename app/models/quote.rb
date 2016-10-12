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

  def get_wording_by_alias( name )
    wordings.find_by_wording_alias_id( WordingAlias.find_by_name( name ) )
  end

  def get_coverage_by_alias( name )
    coverages.find_by_wording_id( get_wording_by_alias(name) )
  end
end
