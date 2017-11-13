module RequestHelper
    
    def prettify_nil(value)
        if value.nil?
            'n/a'
        elsif value.length > 30
            value[0..27] + '...'
        else
            value
        end
    end
    
    def status(request_status)
        case request_status
            when 'n/a'
                'question-circle-o'
            when 'pending'
                'clock-o'
            when 'accepted'
                'car'
            when 'completed'
                'check-circle-o'
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
    
    def find_driver(phone)
        @driver = Driver.find_by(number: phone)
        return @driver
    end
    
    def driver
        @request = Request.find(params[:id])
        @driver = Driver.find_by(number: @request.driver)
        return @driver
    end
    
end
