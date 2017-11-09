class Pharmacy < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
    geocoded_by :full_address
    after_validation :geocode
    has_many :requests
    has_many :patients, :as => :patable
    
    def full_address
        [street, town, state, zipcode].join(', ')
    end
end
