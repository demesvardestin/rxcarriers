class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :item_count
      t.string :shopper_email
      t.string :total_cost
      t.boolean :pending
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
