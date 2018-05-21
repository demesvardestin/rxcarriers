module Color
    
    def get_type_color
        type = self.type
        case type
        when 'refill'
            'theme-blue'
        when 'delivery'
            'theme-green'
        else
            'theme-yellow'
        end
    end
    
end