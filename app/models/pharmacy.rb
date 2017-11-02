class Pharmacy < ActiveRecord::Base
    
    has_many :requests
    has_many :patients, :as => :patable
    
    def full_address
        [street, town, zipcode].join(', ')
    end
end
