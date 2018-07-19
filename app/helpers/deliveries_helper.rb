module DeliveriesHelper
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def signed_on(object)
        [object.signed_on.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ") if object.signed_on
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
                s << "<option value='#{patient.id}' #{'selected' unless patient != chosen_patient}>#{patient.name} - #{patient.dob} - #{patient.address}</option>"
            end
        end
        s.html_safe
    end
    
    def deliveries_today
        id = current_pharmacy.id
        @deliveries = Batch.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, deleted: false)
        @deliveries.count if @deliveries
    end
    
    def requests_today
        id = current_pharmacy.id
        @delivery_requests = RequestAlert.where(pharmacy_id: id, created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, active: true)
        if @delivery_requests
            return @delivery_requests.count
        end
    end
    
    def refills_today
        id = current_pharmacy.id
        @refills = RequestAlert.where(pharmacy_id: id, created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, active: true)
        if @refills != nil
            return @refills.count
        end
    end
    
    def today
        return DateTime.now.strftime("%B %-dth %Y") 
    end
    
    def get_status_color(status)
        if status.nil?
            status = 'on hold'
        end
        case status.downcase
        when 'on hold'
            'theme-yellow'
        when 'refilled'
            'theme-green'
        when 'inactive'
            'theme-red'
        else
            'theme-blue'
        end
    end
    
    def get_type_color(type)
        case type.downcase
        when 'refill'
            'theme-green'
        when 'delivery'
            'theme-blue'
        else
            'theme-yellow'
        end
    end
    
    def notifications
        return Notification.where(pharmacy_id: current_pharmacy.id, read: false).all
    end
    
    def refill_count_today
        id = current_pharmacy.id
        @deliveries = Rx.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, processed: true, deleted: false)
        @deliveries.count if @deliveries
    end
    
    def refill_count_this_week
        id = current_pharmacy.id
        @deliveries = Rx.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_week.utc..Time.now.utc, processed: true, deleted: false)
        @deliveries.count if @deliveries
    end
    
    def refill_count_this_month
        id = current_pharmacy.id
        @deliveries = Rx.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_month.utc..Time.now.utc, processed: true, deleted: false)
        @deliveries.count if @deliveries
    end
    
end
