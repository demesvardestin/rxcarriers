module BatchesHelper
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def find_request(id)
        @request = Request.find_by(batch_id: id)
        begin
            @request.status
        rescue
            'n/a'
        end
    end
    
    def request_status(status)
        case status
            when 'pending'
                'Request Pending...'
            when 'accepted'
                'Request Accepted!'
            when 'completed'
                'Delivery Completed!'
        end
    end
    
    def status_color(status)
        case status
            when 'n/a'
                'black'
            when 'pending'
                'theme-blue'
            when 'accepted'
                'theme-yellow'
            when 'completed'
                'theme-green'
            else
        end
    end
    
end
