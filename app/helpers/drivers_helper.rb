module DriversHelper
    
    def gender(gender = nil)
        s = ''
        genders = ['Select Gender', 'Male', 'Female', 'Other']
        genders.each do |g|
            s << "<option value='#{genders.index(g)}' #{'selected' unless g != gender}>#{g}</option>"
        end
        s.html_safe
    end
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def find_batch(id)
        @batch = Batch.find(id) 
    end
    
    def driver_card_content
        url = request.original_url
        if url.end_with?("/driver/#{current_driver.id}/settings/account-info")
            'form'
        elsif url.end_with?("/driver/#{current_driver.id}/settings/car-info")
            'car_info'
        elsif url.end_with?("/driver/#{current_driver.id}/settings/bank-acct-info")
            'bank_acct_info'
        elsif url.end_with?("/driver/#{current_driver.id}/settings/advanced")
            'advanced'
        else
            'form'
        end
    end
    
    def live_or_complete
        url = request.original_url
        if url.end_with?('/delivery-history')
            return 'completed'
        else
            return 'live'
        end
    end
    
    def pharmacy(object)
        @pharmacy = Pharmacy.find(object.pharmacy_id)
        return @pharmacy
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def joined(driver)
        driver.created_at.strftime("%B %Y")
    end
    
    def amount(batch)
        starting_price = 15
        if batch.deliveries.count == 1
            return starting_price
        end
        total = starting_price + ((batch.deliveries.count - 1) * 3)
        net = total - (total * (15.0/100.0)).to_i
        return net
    end
    
    def time_interval
        url = request.original_url
        path_end = url[url.index("/my-earnings")..-1]
        case path_end
            when '/my-earnings?time=week'
                'week'
            when '/my-earnings?time=month'
                'month'
            when '/my-earnings?time=bot'
                'bot'
        else
            'all'
        end
    end
    
    def interval_type
        url = request.original_url
        path_end = url[url.index("/my-earnings")..-1]
        case path_end
            when '/my-earnings?time=week'
                'This past week'
            when '/my-earnings?time=month'
                'This past month'
            when '/my-earnings?time=bot'
                'The beginning of time'
        else
            'Today'
        end
    end
    
    def shift_status(driver)
        case driver.clocked_in
            when true
                'green'
        else
            'gray'
        end
    end
    
    def support
        url = request.original_url
        if url.include?("support")
            true
        elsif url.include?("welcome")
            true
        elsif url.include?("help")
            true
        end
    end
    
end
