class AddDetailsToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :pharmacy_id, :integer
    add_column :notifications, :batch_id, :integer
    add_column :notifications, :content, :string
    add_column :notifications, :read, :boolean
  end
end
