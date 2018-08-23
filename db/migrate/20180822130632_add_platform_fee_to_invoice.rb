class AddPlatformFeeToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :platform_fee, :string, default: 'n/a'
  end
end
