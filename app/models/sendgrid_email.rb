class SendgridEmail < ActiveRecord::Base
    
    ADMIN_EMAIL = 'hello@rxcarriers.com'
    
    def self.email_pharmacy(to, type, amount=nil)
        subject, content_ = self.get_content(type, amount)
        from =  Email.new(email: ADMIN_EMAIL)
        to = Email.new(email: to)
        subject = subject
        content = Content.new(type: 'text/plain', value: content_)
        mail = Mail.new(from, subject, to, content)
        
        sg = SendGrid::API.new(api_key: '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')
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts response.status_code
        puts response.body
        puts response.headers 
    end
    
    def self.get_content(type, amount)
        case type.downcase
        when 'customer.subscription.trial_will_end'
            subject = 'Your trial is ending soon'
            content = "Greetings from RxCarriers!\n\nThis e-mail is to let you know that
            your trial period will be ending in 3 days. At the end of the 3 days,
            your card will be charged the amount of your subscription plan.\n\n
            If you have any questions, please reach out to #{ADMIN_EMAIL}"
        when 'customer.subscription.updated'
            ## to be decided
        when 'customer.subscription.created'
            subject = 'You are now subscribed to RxCarriers!'
            content = "Greetings from RxCarriers!\n\nThis e-mail is to let you know that
            your trial period has started, and will expire in 7 days. At the end of the 7th day,
            your card will be charged the amount of your subscription plan.\n\n
            If you have any questions, please reach out to #{ADMIN_EMAIL}"
        when 'invoice.upcoming'
            subject = "You have an upcoming invoice for #{amount}"
            content = "Greetings from RxCarriers!\n\nThis e-mail is to let you know that
            you have an upcoming invoice for $#{amount}, which will be charged to the
            account we have on file.\n\nIf you have any questions, please reach out to #{ADMIN_EMAIL}"
        end
        return subject, content
    end
    
end
