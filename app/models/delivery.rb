class Delivery < ActiveRecord::Base
    
    # associations
    belongs_to :deliverable, :polymorphic => true
    belongs_to :pharmacy
    
    # scopes
    scope :reverse_order, -> {order("created_at DESC")}
    
    # validations
    # validates_presence_of :recipient_name
    # validates_presence_of :medications
    # validates_presence_of :copay
    
    # methods
    
    def find_driver(id)
        @request = Request.find_by(batch_id: id)
        if @request
            @driver = Driver.find_by(number: @request.driver)
            return @driver.first_and_initial if @driver
        end
    end
    
    def signed?
        self.signed_on.nil? ? 'No' : 'Yes' 
    end
    
    def signed
        self.signed_on != nil ? true : false
    end
    
end
