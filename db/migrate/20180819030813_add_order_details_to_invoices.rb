class AddOrderDetailsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :order_id, :integer
    add_column :invoices, :transaction_id, :string
    add_column :invoices, :subtotal, :string
    add_column :invoices, :tax, :string
    add_column :invoices, :tip, :string
    add_column :invoices, :final, :string
  end
end
