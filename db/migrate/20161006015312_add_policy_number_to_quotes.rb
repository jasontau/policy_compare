class AddPolicyNumberToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :policy, :string
  end
end
