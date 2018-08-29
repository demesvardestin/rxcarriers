class AddActivatedToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :activated, :boolean, default: true
  end
end
