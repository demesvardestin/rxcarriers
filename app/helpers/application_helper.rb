module ApplicationHelper
    
    def url
        request.original_url 
    end
    
    def render_navigation
        if current_pharmacy
            render 'pharmacies/pharmacy_home'
        else
            render 'layouts/main_nav'
        end
    end
    
    def get_page_title
        if url.include?('contact')
            'Contact Us'
        elsif url.include?('blog')
            'Blog'
        elsif url.include?('status')
            'Rx Status'
        elsif url.include?('for-pharmacies')
            'For Pharmacies'
        elsif url.include?('privacy')
            'Privacy'
        elsif url.include?('terms')
            'Terms'
        elsif url.include?('login') || url.include?('signup')
            'Authentication'
        else
            'Home'
        end
    end
    
    def path
        if url.include?('pharmacy') || url.include?('pharmacies')
            'Pharmacy'
        else
            'Courier'
        end
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def footer
        if current_pharmacy
            'layouts/empty'
        else
            'layouts/footer'
        end
    end
    
    def notifications
        return Notification.where(pharmacy_id: current_pharmacy.id, read: false).all
    end
    
    def notifications_are_present
        return !Notification.find_by(pharmacy_id: current_pharmacy.id, read: false).nil?
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
