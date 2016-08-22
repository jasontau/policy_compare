class AddReferencesToSectionAliases < ActiveRecord::Migration[5.0]
  def change
    add_reference :section_aliases, :insurers, foreign_key: true
  end
end
