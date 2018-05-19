class AddRxNumberToRequestAlerts < ActiveRecord::Migration
  def change
    add_column :request_alerts, :rx, :string
    add_column :request_alerts, :ip, :string
    add_column :request_alerts, :time, :string
  end
end
