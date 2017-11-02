class Pharmacy < ActiveRecord::Base
    
    has_many :requests
    has_many :patients, :as => :patable
    
    def full_address
        [town, state, zipcode].join(', ')
    end
end
