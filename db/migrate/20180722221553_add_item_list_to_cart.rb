class AddItemListToCart < ActiveRecord::Migration
  def change
    add_column :carts, :item_list, :string
    add_column :carts, :item_list_count, :string
    add_column :carts, :instructions_list, :string
  end
end
