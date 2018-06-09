class PharmacyMailer < ApplicationMailer
    include SendGrid
    default from: 'hello@rxcarriers.com'
    
    def welcome_email(pharmacy)
        @pharmacy = pharmacy
        @plan = StripePlan.find_by(pharmacy_id: @pharmacy.id)
        @url  = 'https://rxcarriers.zendesk.com/hc/en-us'
        mail(to: @pharmacy.email, subject: 'Your RxCarriers Subscription')
    end
    
    def new_user_email(pharmacy)
        @pharmacy = pharmacy
        # @url  = 'http://example.com/login'
        mail(to: @pharmacy.email, subject: 'Welcome to RxCarriers!')
    end
end
