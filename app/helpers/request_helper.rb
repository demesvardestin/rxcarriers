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
    
    def request_placeholder_text
        "Search requests by batch id, date sent, status or driver name"
    end
    
    def request_batch(object)
        @batches = Batch.where(pharmacy_id: object.pharmacy_id).all
        begin
            @batch = Batch.find(object.batch_id)
        rescue
            return 'n/a'
        end
        id = @batches.index(@batch) + 1 if @batch
        return id
    end
    
    def request_pharmacy(object)
        @pharmacy = Pharmacy.find(object.pharmacy_id)
        return @pharmacy.name
    end
    
    def find_batch_id(req)
        @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
        begin
            @batch = Batch.find(req.batch_id)
        rescue
            return 'n/a'
        end
        id = @batches.index(@batch) + 1 if @batch
        return id
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
    
    def request_driver(phone)
        begin
            @driver = Driver.find_by(number: phone)
            return @driver
        rescue
            'None yet'
        end
    end
    
    def driver
        @request = Request.find(params[:id])
        if @request.driver.nil?
            return
        end
        begin
            @driver = Driver.find_by(number: @request.driver_number)
        rescue
            'not found'
        end
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def am_pm(object)
        object.updated_at.strftime("%H:%M")[0..1].to_i > 12 ? 'PM' : 'AM'
    end
    
    def request_sort
        url = request.original_url
        url_end = url[url.index("/requests")..-1]
        case url_end
            when "/requests?status=pending"
                return "pending"
            when "/requests?status=accepted"
                return "accepted"
            when "/requests?status=completed"
                return "completed"
            when "/requests?driver=nameasc"
                return "az_driver"
            when "/requests?driver=namedesc"
                return "za_driver"
            when "/requests?date=asc"
                return "asc_date"
            when "/requests?date=desc"
                return "desc_date"
            else
                return "all"
        end
    end
    
    def driver_avatar(driver)
        if driver.avatar
            return 'driver_avi'
        else
            return 'driver_initials'
        end
    end
    
end
