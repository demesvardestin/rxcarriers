class AddSignedOnToTermsAndAgreements < ActiveRecord::Migration
  def change
    add_column :terms_and_agreements, :signed_on, :datetime
  end
end
