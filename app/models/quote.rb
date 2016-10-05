class Quote < ApplicationRecord
  include Policy

  belongs_to :insurer
  belongs_to :account

  mount_uploader :pdf, QuoteUploader
  mount_uploader :csv, QuoteCsvUploader
end
