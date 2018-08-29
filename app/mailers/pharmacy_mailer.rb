class PharmacyMailer < ApplicationMailer
    include SendGrid
    default from: 'hello@rxcarriers.com'
    
    def welcome_email(pharmacy)
        @pharmacy = pharmacy
        mail(to: @pharmacy.email, subject: 'Welcome to RxCarriers!')
    end
    
    def order_in_process(order)
        @order = order
        mail(to: @order.pharmacy.email, subject: "Your order from #{@order.pharmacy.name}")
    end
    
    def registration_approved(registration)
        @registration = registration
        mail(to: @registration.pharmacy_email, subject: "Your registration request has been approved!")
    end
    
    def registration_denied(registration)
        @registration = registration
        mail(to: @registration.pharmacy_email, subject: "Unfortunately, we cannot approve your registration request")
    end
    
    def new_user_email(pharmacy)
        @pharmacy = pharmacy
        # @url  = 'http://example.com/login'
        mail(to: @pharmacy.email, subject: 'Welcome to RxCarriers!')
    end
end
