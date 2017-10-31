class CreateCancellationMessages < ActiveRecord::Migration
  def change
    create_table :cancellation_messages do |t|

      t.timestamps null: false
    end
  end
end
