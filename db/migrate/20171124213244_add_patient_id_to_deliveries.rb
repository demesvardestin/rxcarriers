class AddPatientIdToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :patient_id, :integer
  end
end
