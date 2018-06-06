class CreateTwilioPatients < ActiveRecord::Migration
  def change
    create_table :twilio_patients do |t|

      t.timestamps null: false
    end
  end
end
