class CreateHelpTickets < ActiveRecord::Migration
  def change
    create_table :help_tickets do |t|
      t.integer :pharmacy_id
      t.string :details
      t.string :title
      t.string :phone
      t.string :preferred_time
      t.boolean :processed

      t.timestamps null: false
    end
  end
end
