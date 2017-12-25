class AddDetailsToSupport < ActiveRecord::Migration
  def change
    add_column :supports, :pharmacy_name, :string
    add_column :supports, :pharmacy_email, :string
    add_column :supports, :pharmacy_number, :string
    add_column :supports, :issue_type, :string
    add_column :supports, :pharmacy_id, :integer
  end
end
