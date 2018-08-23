class AddRefundIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :refund_id, :string
  end
end
