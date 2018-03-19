class AddStripeCusToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :stripe_cus, :string
  end
end
