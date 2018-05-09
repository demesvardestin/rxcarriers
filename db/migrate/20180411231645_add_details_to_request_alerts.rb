class AddDetailsToRequestAlerts < ActiveRecord::Migration
  def change
    add_column :request_alerts, :pharm_location, :string
    add_column :request_alerts, :batch_id, :integer
    add_column :request_alerts, :deliveries, :integer
    add_column :request_alerts, :pharm_name, :string
    add_column :request_alerts, :pharm_phone, :string
    add_column :request_alerts, :fare, :string
    add_column :request_alerts, :mileage, :string
    add_column :request_alerts, :duration, :string
    add_column :request_alerts, :driver_id, :integer
    add_column :request_alerts, :pharm_id, :integer
  end
end
