class AddOnTrialToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :on_trial, :boolean
  end
end
