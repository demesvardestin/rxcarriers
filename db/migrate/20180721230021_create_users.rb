class CreateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      ## Database authenticatable
      t.boolean :guest, :default => false
      t.string :name
      t.string :phone
      t.string :street
      t.string :town
      t.string :state
      t.string :zipcode
    end

  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    # raise ActiveRecord::IrreversibleMigration
  end
end
