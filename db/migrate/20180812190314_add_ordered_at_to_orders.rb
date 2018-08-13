class AddOrderedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ordered_at, :datetime
  end
end
