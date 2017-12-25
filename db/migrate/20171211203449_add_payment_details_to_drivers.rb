class AddPaymentDetailsToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :exp_month, :string
    add_column :drivers, :exp_year, :string
    add_column :drivers, :cvc, :string
  end
end
