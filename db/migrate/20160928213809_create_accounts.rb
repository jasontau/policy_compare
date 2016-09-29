class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.text :description
      t.references :customer, foreign_key: true
      t.references :sic, foreign_key: true
      t.references :status, foreign_key: true

      t.timestamps
    end
  end
end
