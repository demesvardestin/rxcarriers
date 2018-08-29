class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :order_id
      t.string :purchase_confirmation
      t.string :code
      t.boolean :activated, default: false
      t.datetime :generated_on

      t.timestamps null: false
    end
  end
end
