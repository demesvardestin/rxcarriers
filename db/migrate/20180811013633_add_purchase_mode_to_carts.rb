class AddPurchaseModeToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :online, :boolean
    add_column :carts, :pharmacy_id, :integer
  end
end
