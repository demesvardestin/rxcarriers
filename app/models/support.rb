class Support < ActiveRecord::Base
    
    # associations
    belongs_to :pharmacy
    
    # validations
    # validates_presence_of :question_details
    # validates_presence_of :pharmacy_name
    # validates_presence_of :pharmacy_number
    # validates_presence_of :pharmacy_email
    # validates_presence_of :issue_type
    
end
