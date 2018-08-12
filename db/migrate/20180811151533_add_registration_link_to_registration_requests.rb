class AddRegistrationLinkToRegistrationRequests < ActiveRecord::Migration
  def change
    add_column :registration_requests, :registration_link, :string
  end
end
