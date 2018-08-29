# Preview all emails at http://localhost:3000/rails/mailers/pharmacy_mailer
class PharmacyMailerPreview < ActionMailer::Preview
    def order_in_process
        PharmacyMailer.order_in_process(Order.last)
    end
    
    def registration_approved
        PharmacyMailer.registration_approved(RegistrationRequest.last)
    end
    
    def registration_denied
        PharmacyMailer.registration_denied(RegistrationRequest.last)
    end
    
    def new_user_email
        PharmacyMailer.with(pharmacy: Pharmacy.first).new_user_email 
    end
    
    def welcome_email
        PharmacyMailer.welcome_email(Pharmacy.first) 
    end
end
