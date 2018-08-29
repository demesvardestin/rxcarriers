module CartHelper
    
    def estimated_delivery(cart_id)
        order = Order.find_by(cart_id: cart_id)
        if order.delivery_option == 'delivery'
            "#{(order.ordered_at + 45.minutes).strftime('%l:%M %p')} - #{(order.ordered_at + 1.hour).strftime('%l:%M %p')}"
        else
            "#{(order.ordered_at + 30.minutes).strftime('%l:%M %p')} - #{(order.ordered_at + 45.minutes).strftime('%l:%M %p')}"
        end
    end
    
    def item_price(item_id, cart, index)
        Item.find_by(id: item_id).price.to_f * cart.item_list_count_array[index].to_i.round(2) 
    end
    
end
