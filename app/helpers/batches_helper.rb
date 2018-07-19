module BatchesHelper
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def batch_placeholder_text
        "Search batches by date or pharmacist"
    end
    
    def find_request(id)
        @request = Request.find_by(batch_id: id)
        begin
            @request.status
        rescue
            'not found'
        end
    end
    
    def find_batch_id(batch)
        @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
        begin
            @batch = Batch.find(batch.id)
        rescue
            return 'n/a'
        end
        id = @batches.index(@batch) + 1 if @batch
        return id
    end
    
    def batch_id(batch)
       @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
       id = @batches.index(batch) + 1
       return id
    end
    
    def request_status(status)
        case status
            when 'pending'
                'Request Pending...'
            when 'accepted'
                'Request Accepted!'
            when 'completed'
                'Delivery Completed!'
            when 'not found'
                'no driver requested'
        end
    end
    
    def status_color(status)
        case status
            when 'n/a'
                'black'
            when 'pending'
                'theme-blue'
            when 'accepted'
                'theme-yellow'
            when 'completed'
                'theme-green'
            else
        end
    end
    
    def batch(req)
        @batch = Batch.find(req.batch_id) if Batch.find(req.batch_id).present?
        return @batch
    end
    
    def batch_sort
        url = request.original_url
        begin
            url_end = url[url.index("/batches")..-1]
        rescue
            'all'
        end
        case url_end
            when "/batches/pending"
                return "pending"
            when "/batches/accepted"
                return "accepted"
            when "/batches/completed"
                return "completed"
            when "/batches/id?order=asc"
                return "asc"
            when "/batches/id?order=desc"
                return "desc"
            when "/batches/packages?order=asc"
                return "asc_packages"
            when "/batches/packages?order=desc"
                return "desc_packages"
            when "/batches?order=timeasc"
                return "asc_date"
            when "/batches?order=timedesc"
                return "desc_date"
            else
                return "all"
        end
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def am_pm(object)
        object.updated_at.strftime("%H:%M")[0..1].to_i > 12 ? 'PM' : 'AM'
    end
    
    def is_disabled?(object)
        begin
            @request = Request.find_by(batch_id: object.id)
            'disabled'
        rescue
            ''
        end
    end
    
    def medications(object)
        meds = object.medications.split(", ")
    end
    
    def accepted(object)
        @batches = object.select do |batch|
            @request = Request.where(batch_id: batch.id, status: "accepted")
            @request.present?
        end
    end
    
    def pending(object)
        @batches = object.select do |batch|
            @request = Request.where(batch_id: batch.id, status: "pending")
            @request.present?
        end
    end
    
    def completed(object)
        @batches = object.select do |batch|
            @request = Request.where(batch_id: batch.id, status: "completed")
            @request.present?
        end
    end
    
    def asc_pharm
        @batches = Batch.where(pharmacy_id: current_pharmacy.id).order("pharmacist ASC").all
        return @batches
    end
    
    def desc_pharm
        @batches = Batch.where(pharmacy_id: current_pharmacy.id).order("pharmacist DESC").all
        return @batches
    end
    
    def asc_packages
        @sorted = []
        @list = []
        Batch.where(pharmacy_id: current_pharmacy.id).each {|batch| @list << [batch, batch.deliveries.count, batch.id]}
        package_count = @list.each {|arr| arr[1]}
        package_count.sort!
        @list.each do |bat|
           package_count.each {|pac| @sorted << bat[0] if bat[1] == pac}
           package_count.delete(bat[1]) if @sorted.include?(bat[1])
        end
        return @sorted
    end
    
    def desc_date
        @batches = Batch.where(pharmacy_id: current_pharmacy.id).order("created_at DESC")
        return @batches
    end
    
    def asc_date
        @batches = Batch.where(pharmacy_id: current_pharmacy.id).order("created_at ASC")
        return @batches
    end
    
    def request_sent(batch)
        (batch.deliveries.count > 0 && batch.completed) || batch.request_status != nil
    end
    
    def current_batch
        id = params[:id]
        return Batch.find(id)
    end
    
    def delivery_count_today
        id = current_pharmacy.id
        @deliveries = Batch.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, delivered: true, deleted: false)
        @deliveries.count if @deliveries
    end
    
    def delivery_count_this_week
        id = current_pharmacy.id
        @deliveries = Batch.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_week.utc..Time.now.utc, delivered: true, deleted: false)
        @deliveries.count if @deliveries
    end
    
    def delivery_count_this_month
        id = current_pharmacy.id
        @deliveries = Batch.where(pharmacy_id: id, requested_at: DateTime.now.at_beginning_of_month.utc..Time.now.utc, delivered: true, deleted: false)
        @deliveries.count if @deliveries
    end
    
    def to_param(string)
        string.downcase.split(' ').join('_') 
    end
    
    def to_price(fee)
        rx_carriers_fee = fee * 0.10
        ((fee + rx_carriers_fee) / 100).to_f.round(2)
    end
    
    def request_btn_text(batch)
        if batch.status == 'initialized'
            'Delivery estimate'
        else
            'Delivery details'
        end
    end
    
end
