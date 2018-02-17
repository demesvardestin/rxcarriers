class AddValueToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :value, :string
  end
end
