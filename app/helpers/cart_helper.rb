module CartHelper
    
    def estimated_delivery(cart_id)
        order = Order.find_by(cart_id: cart_id)
        "#{(order.ordered_at + 45.minutes).strftime('%l:%M %p')} - #{(order.ordered_at + 1.hour).strftime('%l:%M %p')}"
    end
    
end
