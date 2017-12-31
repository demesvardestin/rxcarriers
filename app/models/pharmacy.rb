class Pharmacy < ActiveRecord::Base
  
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
    # associations
    geocoded_by :full_address
    after_validation :geocode
    has_many :requests
    has_many :patients, :as => :patable
    has_one :charge
    has_many :deliveries
    has_many :supports
    
    # validations
    has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    validates :name, presence: true
    validates :street, presence: true
    validates :number, uniqueness: true, presence: true
    validates :website, presence: true
    validates :email, {uniqueness: true, presence: true}
    
    # methods
    def full_address
        [street]
    end
    
    def name_shortened
      if self.name.length > 18
        self.name[0..17] + '...'
      else
        name
      end
    end
    
    def billing_attributes
      self.card_number.present? && self.exp_year.present? && self.exp_month.present? && self.bill_street.present? && self.bill_city.present? && self.bill_state.present? && self.bill_zip.present?
    end
    
end
