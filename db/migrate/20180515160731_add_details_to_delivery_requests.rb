class AddDetailsToDeliveryRequests < ActiveRecord::Migration
  def change
    add_column :delivery_requests, :rx, :string
    add_column :delivery_requests, :active, :boolean
    add_column :delivery_requests, :rx_id, :integer
    add_column :delivery_requests, :pharmacy_id, :integer
  end
end
