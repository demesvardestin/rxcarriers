class AddSubscriptionDetailsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :sub_plan, :string
    add_column :pharmacies, :sub_end_date, :date
    add_column :pharmacies, :is_subscribed, :boolean
    add_column :pharmacies, :delinquent, :boolean
    add_column :pharmacies, :strikes, :integer
  end
end
