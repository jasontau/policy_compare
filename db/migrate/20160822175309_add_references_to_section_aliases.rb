class AddReferencesToSectionAliases < ActiveRecord::Migration[5.0]
  def change
    add_reference :section_aliases, :insurer, foreign_key: true
  end
end
