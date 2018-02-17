class AddStatusToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :stripe_status, :string
  end
end
