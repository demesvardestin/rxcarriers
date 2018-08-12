class AddDetailsToTables < ActiveRecord::Migration
  def change
    add_column :items, :size, :integer
    add_column :items, :size_type, :string
    add_column :items, :invoice_id, :integer
    add_column :items, :expiration, :string
    add_column :orders, :status, :string
  end
end
