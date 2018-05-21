class AddDetailsToRefillDeliveries < ActiveRecord::Migration
  def change
    add_column :refill_deliveries, :rx, :string
    add_column :refill_deliveries, :active, :boolean
    add_column :refill_deliveries, :pharmacy_id, :integer
    add_column :refill_deliveries, :delivery_time, :string
  end
end
