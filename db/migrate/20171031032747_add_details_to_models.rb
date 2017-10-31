class AddDetailsToModels < ActiveRecord::Migration
  def change
    add_column :drivers, :first_name, :string
    add_column :drivers, :last_name, :string
    add_column :drivers, :number, :string
    add_column :drivers, :street, :string
    add_column :drivers, :town, :string
    add_column :drivers, :zipcode, :string
    add_column :requests, :patients, :hash
    add_column :requests, :batch_id, :integer
    add_column :requests, :count, :integer
    add_column :requests, :driver, :array
    add_column :requests, :status, :string
    add_column :requests, :body, :string
    add_column :patients, :name, :string
    add_column :patients, :address, :string
    add_column :patients, :phone, :string
    add_column :patients, :note, :string
    add_column :patients, :copay, :string
    add_column :pharmacies, :name, :string
    add_column :pharmacies, :street, :string
    add_column :pharmacies, :town, :string
    add_column :pharmacies, :zipcode, :string
    add_column :pharmacies, :identifier, :integer
    add_column :charges, :pharmacy_id, :integer
    add_column :charges, :batch_id, :integer
    add_column :request_messages, :pharmacy_id, :integer
    add_column :request_messages, :batch_id, :integer
    add_column :request_messages, :driver_number, :string
    add_column :request_messages, :from_number, :string
    add_column :request_messages, :message_sid, :string
    add_column :request_messages, :date_created, :string
    add_column :request_messages, :message_body, :string
    add_column :request_messages, :type, :string
    add_column :cancellation_messages, :pharmacy_id, :integer
    add_column :cancellation_messages, :batch_id, :integer
    add_column :cancellation_messages, :driver_number, :string
    add_column :cancellation_messages, :from_number, :string
    add_column :cancellation_messages, :message_sid, :string
    add_column :cancellation_messages, :date_created, :string
    add_column :cancellation_messages, :message_body, :string
    add_column :cancellation_messages, :type, :string
    add_column :batches, :notes, :string
    add_column :drivers, :latitude, :float
    add_column :drivers, :longitude, :float
    add_column :pharmacies, :latitude, :float
    add_column :pharmacies, :longitude, :float
    add_column :patients, :latitude, :float
    add_column :patients, :longitude, :float
    add_column :requests, :pharmacy_id, :integer
    add_column :patients, :pharmacy_id, :integer
    add_column :patients, :batch_id, :integer
    add_column :batches, :pharmacy_id, :integer
    add_column :patients, :patable_type, :string
    add_column :patients, :patable_id, :integer
    add_column :request_messages, :date_sent, :string
    add_column :request_messages, :request_type, :string
    add_index :patients, [:patable_type, :patable_id]
  end
end
