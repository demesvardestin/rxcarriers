class AddMoreDetailsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :request_id, :integer
    add_column :invoices, :batch_id, :integer
    add_column :invoices, :billing_date, :timestamp
    add_column :pharmacies, :supervisor, :string
  end
end
