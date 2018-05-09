module DriversHelper
    
    def gender(gender = nil)
        s = ''
        genders = ['Select Gender', 'Male', 'Female', 'Other']
        genders.each do |g|
            s << "<option value='#{genders.index(g)}' #{'selected' unless g != gender}>#{g}</option>"
        end
        s.html_safe
    end
    
    def driver_pay(amount)
        amount_integer = amount.to_f
        fee = amount_integer * 0.15
        fee_round = fee.round(2)
        return (amount_integer - fee_round).round(2)
    end
    
end
