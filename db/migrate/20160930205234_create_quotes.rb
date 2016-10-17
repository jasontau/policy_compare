class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.string :pdf
      t.string :csv
      t.references :insurer, foreign_key: true
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
