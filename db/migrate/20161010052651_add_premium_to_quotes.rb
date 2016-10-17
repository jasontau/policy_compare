class AddPremiumToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :premium, :integer
  end
end
