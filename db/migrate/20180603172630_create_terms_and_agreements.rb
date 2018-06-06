class CreateTermsAndAgreements < ActiveRecord::Migration
  def change
    create_table :terms_and_agreements do |t|
      t.integer :pharmacy_id
      t.boolean :signed

      t.timestamps null: false
    end
  end
end
