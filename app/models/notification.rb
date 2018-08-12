class Notification < ActiveRecord::Base
    
    belongs_to :pharmacy
    
    def request_accepted
        
    end
    
    def not_read
       !self.read == true
    end
    
    def self.unread_all
        self.all.each {|n|
            n.update(read: false)
        }
    end
    
    def self.read_all
        self.all.each {|n|
            n.update(read: true)
        }
    end
    
    def self.notifications_are_present_for(pharmacy_id)
        !Pharmacy.find_by(id: pharmacy_id).notifications.select {|n| n.not_read }.empty? 
    end
    
end
