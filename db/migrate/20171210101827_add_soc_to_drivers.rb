class AddSocToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :soc, :string
    add_column :drivers, :dob, :string
    add_column :drivers, :middle_name, :string
    add_column :drivers, :gender, :string
    add_column :drivers, :onboarded, :boolean
    add_column :drivers, :onfido_created, :boolean
  end
end
