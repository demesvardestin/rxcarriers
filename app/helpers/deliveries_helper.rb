module DeliveriesHelper
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def find_driver(id)
        @request = Request.where(batch_id: id).last
        @driver = Driver.where(number: @request.driver).last
        return @driver
    end
    def patients(chosen_patient = nil)
        s = ''
        Patient.where(pharmacy_id: current_pharmacy.id).each do |patient|
            unless patient.nil?
                s << "<option value='#{patient.id}' #{'selected' unless patient != chosen_patient}>#{patient.name}</option>"
            end
        end
        s.html_safe
    end
    
end
