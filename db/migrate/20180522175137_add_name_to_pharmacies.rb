class AddNameToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :name, :string
    add_column :pharmacies, :town, :string
    add_column :pharmacies, :street, :string
    add_column :pharmacies, :zipcode, :string
  end
end
