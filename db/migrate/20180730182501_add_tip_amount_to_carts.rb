class AddTipAmountToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :tip, :string
    add_column :carts, :tip_amount, :string
  end
end
