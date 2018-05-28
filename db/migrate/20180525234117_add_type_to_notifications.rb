class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notification_type, :string
    add_column :notifications, :rx, :string
    add_column :notifications, :active, :boolean
  end
end
