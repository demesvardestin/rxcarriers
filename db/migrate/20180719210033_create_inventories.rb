class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :pharmacy_id
      t.integer :item_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
