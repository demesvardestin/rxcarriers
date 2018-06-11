class PharmacyMailer < ApplicationMailer
    include SendGrid
    default from: 'hello@rxcarriers.com'
    
    def welcome_email(pharmacy, plan)
        @pharmacy = pharmacy
        @plan = plan
        @url  = 'https://rxcarriers.zendesk.com/hc/en-us'
        mail(to: @pharmacy.email, subject: 'Your RxCarriers Subscription')
    end
    
    def subscription_deleted(pharmacy, plan)
        @pharmacy = pharmacy
        @plan = plan
        @url  = 'https://rxcarriers.zendesk.com/hc/en-us'
        mail(to: @pharmacy.email, subject: 'Your RxCarriers Subscription')
    end
    
    def new_user_email(pharmacy)
        @pharmacy = pharmacy
        # @url  = 'http://example.com/login'
        mail(to: @pharmacy.email, subject: 'Welcome to RxCarriers!')
    end
    
    def successful_billing_notice(pharmacy, plan, amount)
        @pharmacy = pharmacy
        @plan = plan
        @amount = amount
        @url  = 'https://rxcarriers.zendesk.com/hc/en-us'
        @url_ = 'https://www.rxcarriers.com/settings'
        mail(to: @pharmacy.email, subject: 'Billing Notice')
    end
    
    def failed_billing_notice(pharmacy, plan, amount)
        @pharmacy = pharmacy
        @plan = plan
        @amount = amount
        @url  = 'https://rxcarriers.zendesk.com/hc/en-us'
        @url_ = 'https://www.rxcarriers.com/settings'
        mail(to: @pharmacy.email, subject: 'Failed Billing Notice')
    end
    
    def subscription_cancelled(pharmacy, plan, amount)
        @pharmacy = pharmacy
        @plan = plan
        @url  = 'https://rxcarriers.zendesk.com/hc/en-us'
        @url_ = 'https://www.rxcarriers.com/choose_subscription'
        mail(to: @pharmacy.email, subject: 'Failed Billing Notice')
    end
end
