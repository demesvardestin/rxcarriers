class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :controller
      t.string :package
      t.string :create
      t.string :update
      t.string :destroy

      t.timestamps null: false
    end
  end
end
