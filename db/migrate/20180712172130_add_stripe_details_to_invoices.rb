class AddStripeDetailsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :active, :boolean
  end
end
