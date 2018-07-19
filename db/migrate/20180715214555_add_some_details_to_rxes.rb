class AddSomeDetailsToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :requested_at, :date_time
    add_column :rxes, :processed, :boolean
    add_column :rxes, :deleted, :boolean
  end
end
