class AddAvatarToPharmacies < ActiveRecord::Migration
  def up
    add_attachment :pharmacies, :avatar
  end

  def down
    remove_attachment :pharmacies, :avatar
  end
end
