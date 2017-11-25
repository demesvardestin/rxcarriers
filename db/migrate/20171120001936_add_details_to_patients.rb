class AddDetailsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :medications, :string
    add_column :patients, :bank_account_number, :string
    add_column :patients, :country, :string
    add_column :patients, :account_holder_name, :string
    add_column :patients, :account_holder_type, :string
    add_column :patients, :routing_number, :string
  end
end
