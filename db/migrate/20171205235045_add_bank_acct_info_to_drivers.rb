class AddBankAcctInfoToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :bank_account_number, :string
    add_column :drivers, :country, :string
    add_column :drivers, :account_holder_name, :string
    add_column :drivers, :account_holder_type, :string
    add_column :drivers, :routing_number, :string
  end
end
