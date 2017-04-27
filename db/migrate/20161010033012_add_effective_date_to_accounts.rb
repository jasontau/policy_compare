class AddEffectiveDateToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :effective_date, :datetime
  end
end
