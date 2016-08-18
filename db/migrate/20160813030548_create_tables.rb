class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :namedInsured
      t.integer :customerId
      t.integer :quoteId
      t.integer :reportId
      t.integer :sicId
    end

    create_table :customers do |t|
      t.string :name
      t.string :suite
      t.string :address
      t.string :city
      t.string :postalCode
      t.string :country
    end

    create_table :quotes do |t|
      t.integer :insurerId
      t.integer :
  end
end
