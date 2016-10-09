class AddColumnsToWordingAliases < ActiveRecord::Migration[5.0]
  def change
    add_reference :wording_aliases, :section, foreign_key: true
    add_column :wording_aliases, :description, :text
    add_column :wording_aliases, :irmi, :string
  end
end
