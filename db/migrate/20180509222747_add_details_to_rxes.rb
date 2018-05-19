class AddDetailsToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :rx, :string
    add_column :rxes, :last_filled_on, :datetime
    add_column :rxes, :current_status, :string
    add_column :rxes, :pharmacy_id, :integer
    add_column :rxes, :batch_id, :integer
    add_column :rxes, :patient_id, :integer
    add_column :rxes, :phone_number, :string
    add_column :rxes, :address, :string
  end
end
