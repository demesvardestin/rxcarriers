class AddBillingInfoToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :bank_account_number, :string
    add_column :pharmacies, :country, :string
    add_column :pharmacies, :account_holder_name, :string
    add_column :pharmacies, :account_holder_type, :string
    add_column :pharmacies, :routing_number, :string
  end
end
