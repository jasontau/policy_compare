class Section < ApplicationRecord
  has_many :section_aliases, dependent: :nullify
  has_many :wording_aliases, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
