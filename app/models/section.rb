class Section < ApplicationRecord
  has_many :section_aliases

  validates :name, presence: true, uniqueness: true
end
