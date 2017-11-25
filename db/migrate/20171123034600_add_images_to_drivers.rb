class AddImagesToDrivers < ActiveRecord::Migration
  def up
    add_attachment :drivers, :avatar
  end

  def down
    remove_attachment :drivers, :avatar
  end
end
