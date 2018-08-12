class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :pharmacy_id
      t.integer :category_id
      t.integer :inventory_id
      t.string :name
      t.string :price
      t.string :quantity
      t.string :details

      t.timestamps null: false
    end
  end
end
