class AddCurrentLocationToShoppers < ActiveRecord::Migration
  def change
    add_column :carts, :current_location, :string
  end
end
