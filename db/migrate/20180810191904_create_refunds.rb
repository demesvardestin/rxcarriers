class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.string :amount
      t.integer :order_id
      t.integer :pharmacy_id
      t.boolean :completed
      t.string :details
      t.string :stripe_cus

      t.timestamps null: false
    end
  end
end
