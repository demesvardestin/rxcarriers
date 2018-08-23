class TwilioPatient < ActiveRecord::Base
    
    def self.alert_customer(phone, message, pharmacy=nil)
        twilio, twilio_phone = self.twilio
        twilio.messages.create(
            body: message,
            to: phone,
            from: twilio_phone
        )
    end
    
    def self.bulk_call(pharmacy, unpicked_meds_batch=nil, issue_present_batch=nil)
        if !unpicked_meds_batch.nil?
            message_unpicked, twilio_unpicked, twilio_phone_unpicked = self.twilio('unpicked prescriptions', pharmacy)
            message_unpicked = "Hi there! You have some medications that have not been picked up at #{pharmacy}. Please stop by or request a delivery at rxcarriers.com/status"
            unpicked_meds_batch.each do |b|
                twilio_unpicked.calls.create(
                    to: b.phone_number,
                    from: twilio_phone_unpicked,
                    url: "https://udemy-class-demo07.c9users.io/call/#{URI.encode("Hi, this message is to let you know that your medication is ready for pickup at #{pharmacy}")}"
                )
            end
        end
        if !issue_present_batch.nil?
            message_issue_present, twilio_issue_present, twilio_phone_issue_present = self.twilio('inactive', pharmacy)
            message_issue_present = "Hi, this message is from #{pharmacy}. Please give us a call at your earliest convenience."
            issue_present_batch.each do |b|
                twilio_issue_present.calls.create(
                    to: b.phone_number,
                    from: twilio_phone_issue_present,
                    url: "https://udemy-class-demo07.c9users.io/call/#{URI.encode("Hi, this message is from #{pharmacy}, please give us a call at your earliest convenience")}"
                )
            end
        end
    end
    
    def self.bulk_message(pharmacy, unpicked_meds_batch=nil, issue_present_batch=nil)
        if !unpicked_meds_batch.nil?
            message_unpicked, twilio_unpicked, twilio_phone_unpicked = self.twilio('unpicked prescriptions', pharmacy)
            unpicked_meds_batch.each do |b|
                begin
                    twilio_unpicked.messages.create(
                        body: message_unpicked,
                        to: b.phone_number,
                        from: twilio_phone_unpicked
                    )
                rescue
                    begin
                        twilio_unpicked.calls.create(
                            to: b.phone_number,
                            from: twilio_phone_unpicked,
                            url: "https://udemy-class-demo07.c9users.io/call/#{URI.encode("Hi, this message is to let you know that your medication is ready for pickup at #{pharmacy}")}"
                        )
                    rescue
                        next
                    end
                end
            end
        end
        if !issue_present_batch.nil?
            message_issue_present, twilio_issue_present, twilio_phone_issue_present = self.twilio('inactive', pharmacy)
            issue_present_batch.each do |b|
                begin
                    twilio_issue_present.messages.create(
                        body: message_issue_present,
                        to: b.phone_number,
                        from: twilio_phone_issue_present
                    )
                rescue
                    begin
                        twilio_issue_present.calls.create(
                            to: b.phone_number,
                            from: twilio_phone_issue_present,
                            url: "https://udemy-class-demo07.c9users.io/call/#{URI.encode("Hi, this message is from #{pharmacy}, please give us a call at your earliest convenience")}"
                        )
                    rescue
                        next
                    end
                end
            end
        end
    end
    
    def self.message_patient(phone, message)
        auto_message, twilio, twilio_phone = self.twilio
        auto_message = message if message
        twilio.messages.create(
            body: message,
            to: phone,
            from: twilio_phone
        )
    end
    
    def self.get_message(type, pharmacy)
        type.nil? ? type = 'nil' : type
        case type.downcase
        when 'refill request'
            self.refill_request(pharmacy)
        when 'delivery request'
            self.delivery_request(pharmacy)
        when 'refill ready'
            self.refill_ready(pharmacy)
        when 'delivery sent'
            self.delivery_sent(pharmacy)
        when 'inactive'
            self.refill_inactive(pharmacy)
        when 'unpicked prescriptions'
            self.unpicked_prescriptions(pharmacy)
        else
            self.refill_updated(pharmacy)
        end
    end
    
    def self.refill_request(pharmacy)
        return "RxCarriers: Hi there! Your refill request has been sent to #{pharmacy}. You'll receive a text message once it's ready."
    end
    
    def self.unpicked_prescriptions(pharmacy)
        return "RxCarriers: Hi there! You have some prescriptions that have not been picked up at #{pharmacy}. Please give us a visit or request a delivery at rxcarriers.com/status"
    end
    
    def self.delivery_request(pharmacy)
        return "RxCarriers: Great! Your delivery request has been sent to #{pharmacy}. You'll receive a text message once your medication is on the way."
    end
    
    def self.refill_ready(pharmacy)
        return "RxCarriers: Great news! Your refill is ready to be picked up at #{pharmacy}. You may request a delivery at rxcarriers.com/status"
    end
    
    def self.delivery_sent(pharmacy)
        return "RxCarriers: Hey! Your medicine delivery from #{pharmacy} is now on the way. We estimate that it should arrive within the next 60-75mns. Make sure to have someone available to sign for it!"
    end
    
    def self.refill_updated(pharmacy)
        return "RxCarriers: Hey there! An update has been made to your prescription at #{pharmacy}. This may mean that there is an issue with your insurance, or that your refills have run out. We recommend contacting the pharmacy at your earliest convenience."
    end
    
    def self.refill_inactive(pharmacy)
        return "RxCarriers: Hey there! There seems to be an issue with your prescription at #{pharmacy}. Please contact the pharmacy at your earliest convenience."
    end
    
    def self.get_call_text(type)
        if type == 'unpicked'
            return "Hi, this is an automated call to let you know that your medication is ready for pickup at #{pharmacy}."
        elsif type == 'issue'
            return "Hi, this is an automated call to let you know that there's an issue with your refill at #{pharmacy}"
        end
    end
    
    def self.twilio
        twilio = self.initialize_twilio
        # twilio_phone = ENV["TWILIO_PHONE"]
        twilio_phone = '12018491397'
        return twilio, twilio_phone
    end
    
    def self.twilio_token
        ENV["TWILIO_TOKEN"]
    end
    
    def self.initialize_twilio
        # account_sid = ENV["TWILIO_SID"]
        account_sid = 'AC372a0064c4d35fd5aaeea6c791fb8663'
        # auth_token = ENV["TWILIO_TOKEN"]
        auth_token = 'd08b231a3e1026c359dcc6b2f916c851'
        return Twilio::REST::Client.new account_sid, auth_token
    end
    
end
