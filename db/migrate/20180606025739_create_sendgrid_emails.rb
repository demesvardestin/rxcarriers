class CreateSendgridEmails < ActiveRecord::Migration
  def change
    create_table :sendgrid_emails do |t|

      t.timestamps null: false
    end
  end
end
