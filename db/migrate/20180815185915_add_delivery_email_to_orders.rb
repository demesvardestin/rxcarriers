class AddDeliveryEmailToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_email, :string
  end
end
