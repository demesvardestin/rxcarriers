class AddBirthYearToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :birth_year, :string
    add_column :rxes, :confirmation, :string
  end
end
