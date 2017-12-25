class AddStripeTokenToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :stripe_token, :string
  end
end
