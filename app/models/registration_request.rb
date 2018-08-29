class RegistrationRequest < ActiveRecord::Base
    
    validates_presence_of :pharmacy_name
    validates_presence_of :pharmacy_email
    validates_presence_of :pharmacy_phone
    validates_presence_of :pharmacy_address
    validates_presence_of :pharmacy_manager
    # validates_uniqueness_of :secure_token
    
    
    def self.generate_token
        random_token = SecureRandom.urlsafe_base64(nil, false)
        if self.exists?(secure_token: random_token)
            generate_token
        end
        return random_token
    end
    
    def approve_registration
        token = RegistrationRequest.generate_token
        link = "https://udemy-class-demo07.c9users.io/pharmacy/signup?approved=true&pharmacy=verified&secure_token=#{token}"
        self.update(secure_token: token, registration_link: link)
        reg = RegistrationRequest.find_by(id: self.id)
        PharmacyMailer.registration_approved(reg).deliver_now
    end
    
    def deny_registration
        self.update(denied_on: Time.zone.now)
        reg = RegistrationRequest.find_by(id: self.id)
        PharmacyMailer.registration_denied(reg).delivery_now
    end
end
