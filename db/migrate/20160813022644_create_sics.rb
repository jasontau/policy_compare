class CreateSics < ActiveRecord::Migration[5.0]
  def change
    create_table :sics do |t|
      t.integer :code
      t.string :name
      t.string :segment

      t.timestamps
    end
  end
end
