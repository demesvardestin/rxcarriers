class AddPharmacyIdToRequestAlerts < ActiveRecord::Migration
  def change
    add_column :request_alerts, :pharmacy_id, :integer
  end
end
