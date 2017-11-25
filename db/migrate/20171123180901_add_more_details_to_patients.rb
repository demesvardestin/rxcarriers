class AddMoreDetailsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :dob, :string
    add_column :patients, :insured, :string
  end
end
