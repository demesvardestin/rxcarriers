class AddDateOfBirthToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :dob, :string
  end
end
