class CreateRequestAlerts < ActiveRecord::Migration
  def change
    create_table :request_alerts do |t|

      t.timestamps null: false
    end
  end
end
