class Charge < ActiveRecord::Base
    
    def initialize
        @charges = []
    end
  
    def charge_flow
        @charges << 35 # this is an arbitrary number. you can choose any value you prefer
        @charges
    end
  
    def extra_mile_fee(miles)
        @charges << miles * 100 # chargin 
    end
    
end
