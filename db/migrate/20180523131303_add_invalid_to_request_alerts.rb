class AddInvalidToRequestAlerts < ActiveRecord::Migration
  def change
    add_column :request_alerts, :is_valid, :boolean
    add_column :request_alerts, :request_ip, :string
    add_column :delivery_requests, :is_valid, :boolean
    add_column :delivery_requests, :request_ip, :string
  end
end
