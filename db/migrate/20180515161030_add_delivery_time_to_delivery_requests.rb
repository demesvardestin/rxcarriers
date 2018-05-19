class AddDeliveryTimeToDeliveryRequests < ActiveRecord::Migration
  def change
    add_column :delivery_requests, :delivery_time, :string
  end
end
