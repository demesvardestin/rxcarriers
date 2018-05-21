# class AddIndexToPackages < ActiveRecord::Migration
#   def change
#     add_column :packages, :packageable_type, :string
#     add_column :packages, :packageable_id, :integer
#     add_column :packages, :recipient_name, :string
#     add_column :packages, :recipient_phone_number, :string
#     add_column :packages, :recipient_address, :string
#     add_column :packages, :medications, :string
#     add_index :packages, [:packageable_type, :packageable_id]
#   end
# end
