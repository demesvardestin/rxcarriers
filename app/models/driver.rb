class Driver < ActiveRecord::Base
    
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
    # geocoding
    geocoded_by :full_address
    after_validation :geocode
    
    # scopes
    scope :on_shift, -> {where(clocked_in: true)}
    scope :available, -> {where(requested: false)}
    scope :approved, -> {where(driver_approved: true)}
    
    # validations
    has_attached_file :avatar, styles: { medium: "300x300>", thumb: "64x64>" }
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    
    # methods
    
    def car_info
        self.car_color + ' ' + self.car_year + ' ' + self.car_make + ' ' + self.car_model 
    end
    
    def stripe_token_present?
        self.stripe_token.nil? ? 'false' : 'true' 
    end
    
    def connected
        self.stripe_uid.present? ? true : false
    end
    
    def approved
        self.driver_approved == true ? true : false
    end
    
    def full_address
        [street, town, state, zipcode].join(", ")
    end
    
    def full_name
        [first_name, last_name].join(" ") 
    end
    
    def first_and_initial
        [self.first_name, self.last_name[0]].join(" ") + '.'
    end
    
    def initials
        self.first_name[0] + self.last_name[0] 
    end
    
    
    
    def self.initialize_twilio
        account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
        auth_token = '2a27c125b10a4429e8a24ccd08584670'
        @client = Twilio::REST::Client.new(account_sid, auth_token)
        return @client
    end
    
    
    def self.raise_error(driver)
        error_msg = "[Type: invalid command]\n\nThe command you entered is invalid."
        self.initialize_twilio.api.account.messages.create(
            from: '+13474640621',
            to: driver.number,
            body: error_msg
        )
    end
    
end
