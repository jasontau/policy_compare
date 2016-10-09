class AddReferenceToWordings < ActiveRecord::Migration[5.0]
  def change
    add_reference :wordings, :wording_alias, foreign_key: true
  end
end
