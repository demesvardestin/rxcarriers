class PharmacyMailer < ApplicationMailer
    include SendGrid
    default from: 'hello@rxcarriers.com'
    
    def welcome_email(pharmacy)
        @pharmacy = pharmacy
        @plan = StripePlan.find_by(pharmacy_id: @pharmacy.id)
        # @url  = 'http://example.com/login'
        mail(to: @pharmacy.email, subject: 'Welcome to My Awesome Site')
    end
end
