class AddFirebaseIdToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :firebase_id, :string
  end
end
