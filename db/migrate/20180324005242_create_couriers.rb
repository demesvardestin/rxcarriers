class CreateCouriers < ActiveRecord::Migration
  def change
    create_table :couriers do |t|

      t.timestamps null: false
    end
  end
end
