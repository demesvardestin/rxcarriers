class Pharmacy < ActiveRecord::Base
  
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
    geocoded_by :full_address
    after_validation :geocode
    has_many :requests
    has_many :patients, :as => :patable
    has_one :charge
    
    def full_address
        [street]
    end
    
    def name_shortened
      if self.name.length > 12
        self.name[0..9] + '...'
      else
        name
      end
    end
    
    def self.search(string)
      split_string = string.scan(/\w+/)
      first_start = split_string[0][0..3]
      first_end = split_string[0][-1,3]
      last_start = split_string[1][0..3] if split_string.length > 1
      last_end = split_string[1][-1,3] if split_string.length > 1
      results = Pharmacy.select do |ph|
        total = self.check_start(ph.name.downcase.scan(/\w+/)[0], first_start, last_start) + 
              self.check_end(ph.name.downcase.scan(/\w+/)[1], first_end, last_end) + 
              self.check_word(ph.name, string)
        total >= 1
      end
      return results
    end
    
    def self.check_start(x, y, z=nil)
      counter = 0
      counter += 1 if x.start_with?(y)
      counter += 1 if z != nil && x.start_with?(z)
      return counter
    end
    
    def self.check_end(x, y, z=nil)
      counter = 0
      counter += 1 if x.end_with?(y)
      counter += 1 if z != nil && x.end_with?(z)
      return counter
    end
    
    def self.check_word(x, y)
      counter = 0
      x == y ? counter += 1 : counter = 0
      return counter
    end
    
end
