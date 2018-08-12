module CartHelper
    
    def estimated_delivery
        "#{45.minutes.from_now.to_time.strftime('%l:%M %p')} - #{1.hour.from_now.to_time.strftime('%l:%M %p')}"
    end
    
end
