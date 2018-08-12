class AddDeliveryOptionToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :delivery_option, :string, default: 'delivers'
  end
end
