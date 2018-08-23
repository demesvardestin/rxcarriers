class AddDeliveryOptionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_option, :string
    add_column :orders, :default, :delivery
  end
end
