class AddDeliveryDetailsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :street_address, :string
    add_column :orders, :town_state_zipcode, :string
    add_column :orders, :phone_number, :string
    add_column :orders, :apartment_number, :string
    add_column :orders, :processed, :boolean
    add_column :orders, :requested_at, :date_time
  end
end
