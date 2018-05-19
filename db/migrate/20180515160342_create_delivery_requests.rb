class CreateDeliveryRequests < ActiveRecord::Migration
  def change
    create_table :delivery_requests do |t|
      # t.rx :string

      t.timestamps null: false
    end
  end
end
