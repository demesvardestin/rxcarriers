class AddAmountToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :amount, :string
  end
end
