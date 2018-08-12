class Delivery < ActiveRecord::Base
    
    # associations
    belongs_to :deliverable, :polymorphic => true
    belongs_to :pharmacy
    
    # scopes
    scope :reverse_order, -> {order("created_at DESC")}
    scope :incomplete, -> {where(completed: false)}
    scope :not_deleted, -> {where(deleted: false)}
    scope :deleted, -> {where(deleted: true)}
    
    # validations
    # validates_presence_of :recipient_name
    # validates_presence_of :medications
    # validates_presence_of :copay
    
    # methods
    
    def delete_all
       self.all.each {|d| d.delete } 
    end
    
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
    
    def pharmacy
        pharmacy_id = self.pharmacy_id
        return Pharmacy.find(pharmacy_id)
    end
    
    def has_signature?
        if self.signature_image.nil?
            return 'Pending'
        else
            return self.signature_image
        end
    end
    
    def to_mm_dd_yy(date)
        if date
            return [date.strftime("%m/%d/%Y"), 'at', date.strftime("%I:%M %p")].join(' ')
        else
            'n/a'
        end
    end
    
end
