class AddRelationalIdsToModels < ActiveRecord::Migration
  def change
    add_column :inventories, :item_category_id, :integer
    add_column :pharmacies, :item_category_id, :integer
    add_column :items, :item_category_id, :integer
  end
end
