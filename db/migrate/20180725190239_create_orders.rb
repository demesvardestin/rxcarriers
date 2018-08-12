class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :cart_id
      t.integer :pharmacy_id
      t.string :shopper_email
      t.string :item_list
      t.string :item_list_count
      t.string :total
      t.string :stripe_charge_id
      t.string :confirmation
      t.boolean :guest

      t.timestamps null: false
    end
  end
end
