class AddFinalDetailsToCart < ActiveRecord::Migration
  def change
    add_column :carts, :order_id, :integer
    add_column :carts, :final_amount, :string
  end
end
