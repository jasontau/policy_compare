class CreateWordings < ActiveRecord::Migration[5.0]
  def change
    create_table :wordings do |t|
      t.string :form
      t.string :name
      t.text :verbiage
      t.references :insurer, foreign_key: true

      t.timestamps
    end
  end
end
