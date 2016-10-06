class CreateCoverages < ActiveRecord::Migration[5.0]
  def change
    create_table :coverages do |t|
      t.integer :deductible
      t.integer :deductible_percent
      t.integer :limit
      t.references :quote, foreign_key: true
      t.references :wording, foreign_key: true

      t.timestamps
    end
  end
end
