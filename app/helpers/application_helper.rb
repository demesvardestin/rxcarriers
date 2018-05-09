module ApplicationHelper
    
    def driver_status
        if (current_driver.onboarding_complete == true) || (current_driver.onfido_created == true && current_driver.registration_completed.nil?)
            'drivers/driver_home'
        elsif current_driver.onfido_created == nil
            'drivers/acct_under_review'
        end
    end
    
    def render_navigation
        if current_pharmacy
            render 'pharmacies/pharmacy_home'
        elsif current_driver
            render 'layouts/driver_logged_out_nav'
        else
            render 'layouts/main_nav'
        end
    end
    
    def path
        if url.include?('pharmacy')
            'Pharmacy'
        else
            'Courier'
        end
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def footer
        if current_pharmacy or current_driver
            'layouts/empty'
        else
            'layouts/footer'
        end
    end
    
    def notifications
        return Notification.where(pharmacy_id: current_pharmacy.id, read: false).all
    end
    
    def current_courier
        return Courier.find_by(cid: params[:cid]) 
    end
    
    def uri_escape(string)
        return URI.escape(string)
    end
    
    def to_mm_dd_yy(date)
        if date
            return [date.strftime("%m/%d/%Y"), 'at', date.strftime("%I:%M %p")].join(' ')
        else
            'n/a'
        end
    end
    
    def active_li(url_keyword)
        if url.include?(url_keyword)
            'active_li'
        end
    end
    
    def decoded_vapid
        return "#{Rails.application.secrets.vapid_public}"
    end
    
end
