class AddActiveToRequestAlerts < ActiveRecord::Migration
  def change
    add_column :request_alerts, :active, :boolean
  end
end
