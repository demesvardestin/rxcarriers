class AddDetailsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :pharmacy_id, :integer
    add_column :invoices, :description, :string
    add_column :invoices, :stripe_invoice_id, :string
    add_column :invoices, :amount, :integer
    add_column :invoices, :currency, :string
    add_column :invoices, :paid, :boolean
    add_column :drivers, :stripe_uid, :string
  end
end
