class WordingAlias < ApplicationRecord
  has_many :wordings, dependent: :nullify
  belongs_to :section

  validates :name, presence: true, uniqueness: true

  def self.get_all_property
    where("section_id = ? OR section_id = ? OR section_id = ? OR section_id = ?",
          Section.find_by_name("Property"),
          Section.find_by_name("Catastrophe"),
          Section.find_by_name("Business Interruption"),
          Section.find_by_name("Equipment Breakdown")
          )
  end

  def self.get_liability
    where("section_id = ?",
          Section.find_by_name("Liability")
          )
  end
end
