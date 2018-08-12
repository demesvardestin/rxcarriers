class AddAdditionalDetailsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :online, :boolean
  end
end
