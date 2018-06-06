class CreateStripePlans < ActiveRecord::Migration
  def change
    create_table :stripe_plans do |t|
      t.string :name
      t.integer :pharmacy_id
      t.datetime :next_billing_date
      t.boolean :active

      t.timestamps null: false
    end
  end
end
