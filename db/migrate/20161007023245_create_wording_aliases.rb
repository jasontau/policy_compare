class CreateWordingAliases < ActiveRecord::Migration[5.0]
  def change
    create_table :wording_aliases do |t|
      t.string :name

      t.timestamps
    end
  end
end
