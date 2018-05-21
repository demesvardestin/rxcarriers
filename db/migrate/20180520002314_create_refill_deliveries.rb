class CreateRefillDeliveries < ActiveRecord::Migration
  def change
    create_table :refill_deliveries do |t|

      t.timestamps null: false
    end
  end
end
