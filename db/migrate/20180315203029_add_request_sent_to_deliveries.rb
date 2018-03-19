class AddRequestSentToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :request_sent, :boolean
  end
end
