class AddLiveStatusToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :live, :boolean, default: false
  end
end
