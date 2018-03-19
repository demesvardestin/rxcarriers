class Batch < ActiveRecord::Base
    
    # associations
    belongs_to :pharmacy
    has_many :deliveries, :as => :deliverable
    
    # scopes
    scope :asc, -> {order("ID ASC")}
    scope :desc, -> {order("ID DESC")}
    scope :asc_date, -> {order("updated_at ASC")}
    scope :desc_date, -> {order("updated_at DESC")}
    scope :requested, -> {where(request_status: 'completed')}
    scope :today, -> {where("created_at >= ?", Time.zone.now.beginning_of_day)}
    scope :last_week, -> {where("created_at >= ?", 1.week.ago)}
    scope :last_month, -> {where("created_at >= ?", 1.month.ago)}
    
    # validations
    # validates_presence_of :notes
    # validates_presence_of :pharmacist
    
    # methods
    def self.today
        where("created_at >= ?", Time.zone.now.beginning_of_day)
    end
    
    def self.last_week
        where("created_at >= ?", 1.week.ago)
    end
    
    def self.last_month
        where("created_at >= ?", 1.month.ago)
    end
    
    def self.search(param)
        where('pharmacist LIKE ?', "%#{param}%")
    end
    
    def self.includes(batch, string)
        counter = 0
        counter += 1 if batch.pharmacist.include?(string)
        return counter
    end
    
    def self.was_created(batch, time)
        counter = 0
        counter += 1 if self.timestamp(batch).include?(time)
        return counter
    end
    
    def self.timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def self.search(param)
        param.strip!
        param.downcase!
        (id_matches(param) + pharmacist_matches(param)).uniq
    end
    
    def self.id_matches(param)
        matches('id', param)
    end
    
    def self.pharmacist_matches(param)
        matches('pharmacist', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
    
    def to_miles(dist)
        return (dist * 0.000621371).round(2)
    end
    
    def to_minutes(time)
        return (time/60)
    end
    
    def to_dollars(amount)
        return (amount/100).round(2)
    end
    
    def calculate_request_details(batch)
        mileage, duration = Batch.calculate_route_details(batch)
        base_fare = 500
        per_mile = 100
        per_minute = 20
        total_fare = base_fare + (to_miles(mileage) * per_mile) + (to_minutes(duration) * per_minute)
        return to_dollars(total_fare), to_miles(mileage), to_minutes(duration)
    end
    
    def self.parse_response(from, resp)
        @driver = Driver.find_by(number: from)
        case resp
            when 'yes'
              Batch.respond_to_driver(@driver)
            when 'cancel pickup'
              Batch.cancel_driver(@driver)
            when 'clock in'
              Driver.clock_in(@driver)
            when 'clock out'
              Driver.clock_out(@driver)
            else
              Driver.raise_error(@driver)
        end 
    end
    
    def self.respond_to_driver(driver)
        Batch.initialize_twilio
        @initial_request_message = RequestMessage.where(driver_number: driver.number, driver: nil).last
        @pharmacy = Pharmacy.find(@initial_request_message.pharmacy_id)
        directions = "Thank you for accepting, #{driver.first_name}. Your pickup is now ready at #{@pharmacy.name}.\nFor verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel pickup'."
        @new_request = Request.where(body: @initial_request_message.message_body, pharmacy_id: @pharmacy.id, driver: nil, count: 0).last
        @batch = Batch.find_by(batch_id: @new_request.batch_id)
        @batch.update(driver: driver.number, request_status:'accepted')
        counter = @new_request.count
        counter += 1
        @new_request.update(status: 'accepted', count: counter)
        if @new_request.count == 1
            @client.api.account.messages.create(
                from: '+13474640621',
                to: driver.number,
                body: directions
            )
            @new_request.update(
                driver_name: driver.first_name,
                driver_number: driver.number,
                car_make: driver.car_make,
                car_model: driver.car_model,
                car_year: driver.car_year,
                car_color: driver.car_color,
                license_plate: driver.liecnse_plate
            )
            Driver.notify_drivers_request_invalidated(driver)
        end
    end
    
    def self.cancel_driver(driver)
        Batch.initialize_twilio
        @request_message = RequestMessage.where(driver_number: driver.number, driver: driver.number, status: 'in progress').last
        unless @request_message.nil?
            @pharmacy = Pharmacy.find(@request_message.pharmacy_id)
            @initial_request = Request.where(driver: driver.number, status: 'accepted', body: @request_message.message_body).last
            @initial_request.update(status: 'pending', count: 0, driver: nil)
            @request_message.update(driver: nil)
            Request.resend_request(@initial_request.batch_id, @pharmacy, @initial_request, driver, @request_message)
        end 
    end
    
    def completed
        counter = 0
        self.deliveries.each do |bat|
            bat.signed ? counter += 1 : counter += 0 
        end 
        counter == self.deliveries.count ? true : false
    end
    
    def self.delivery_completed(driver)
        counter = 0
        @batch = Batch.find_by(driver: driver, request_status:'accepted')
        @batch.deliveries.each do |bat|
            if bat.signed
                counter += 1
            end
        end
        if counter == @batch.deliveries.count
            @driver = Driver.find_by(number: driver)
            @driver.update(requested: false)
            @pharmacy = Pharmacy.find(@batch.pharmacy_id)
            @request_message = RequestMessage.where(driver_number: driver, driver: driver, status: 'in progress').last
            @request_message.update(status: 'completed')
            @new_request = Request.find_by(status: 'accepted', driver: driver, body: @request_message.message_body)
            @new_request.update(status: 'completed')
            amount = @batch.total_amount
            @batch.update(request_status: 'completed')
            Charge.charge_pharmacy(@pharmacy, @batch, @driver, @new_request, amount)
        end
    end
    
    def total_amount
        starting_price = 1500
        if self.deliveries.count == 1
            return starting_price
        end
        total = starting_price + ((self.deliveries.count - 1) * 400)
        return total 
    end
    
    def self.calculate_route_details(batch)
        pharmacy = Pharmacy.find(batch.pharmacy_id)
        origin = pharmacy.full_address
        mileage = 0
        duration = 0
        if batch.deliveries.count > 1
            deliveries = optimize_route(batch, pharmacy.full_address)
            deliveries.each do |d|
               mileage += d.matrix.to_i
               duration += d.duration.to_i
            end
        else
            deliveries = batch.deliveries
            deliveries.each do |d|
                destination = d.recipient_address
                total = Batch.matrix(origin, destination)
                dist = total[:rows][0][:elements][0][:distance][:value]
                time = total[:rows][0][:elements][0][:duration][:value]
                mileage += dist
                duration += time
                d.update(matrix: dist, duration: time)
                origin = d.recipient_address
            end
        end
        return mileage, duration
    end
    
    def self.optimize_route(batch, origin=nil, output=[], distances=[], i=0)
        deliveries = batch.deliveries
        (deliveries - output).each do |d|
            destination = d.recipient_address
            total = Batch.matrix(origin, destination)
            dist = total[:rows][0][:elements][0][:distance][:value]
            time = total[:rows][0][:elements][0][:duration][:value]
            distances << dist
            d.update(matrix: dist, duration: time)
        end
        distances = distances.sort!
        deliveries.each do |deliv|
            if deliv.matrix.to_i == distances[0]
                output << deliv
            end
        end
        origin = output.last
        i += 1
        if i == deliveries.count - 1
            return [output << (deliveries - output)].flatten
        end
        self.optimize_route(batch, origin.recipient_address, output, distances=[], i)
    end
    
    def self.matrix(origin, destination)
        return Batch.gmaps.distance_matrix(origin, destination,
                            mode: 'driving',
                            language: 'en-AU',
                            avoid: 'tolls',
                            units: 'imperial') 
    end
    
    def self.gmaps
        GoogleMapsService::Client.new(
            key: 'AIzaSyBjzZwLgeCXetH1WN6_HkCemsABzINX0UU',
            client_id: 'dispenserx-196018',
        )
    end
    
    def self.delete_twilio_messages(driver)
        @client.api.account.messages.list(
            from: '+13474640621',
            to: driver.number
        ).each do |message|
           message.delete 
        end
        @client.api.account.messages.list(
            from: driver.number,
            to: '+13474640621'
        ).each do |message|
           message.delete 
        end
    end
    
    def self.initialize_twilio
        account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
        auth_token = '2a27c125b10a4429e8a24ccd08584670'
        @client = Twilio::REST::Client.new account_sid, auth_token
    end
    
end