class Pharmacy < ActiveRecord::Base
    
    has_many :requests
    has_many :patients, :as => :patable
    
end
