class CreateInsurers < ActiveRecord::Migration[5.0]
  def change
    create_table :insurers do |t|
      t.string :name
      t.string :am_best_rating

      t.timestamps
    end
  end
end
