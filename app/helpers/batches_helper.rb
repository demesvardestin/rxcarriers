module BatchesHelper
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def batch_placeholder_text
        "Search batches by date created or pharmacist name"
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
            when "/batches/pharmacist?order=az"
                return "az_pharmacist"
            when "/batches/pharmacist?order=za"
                return "za_pharmacist"
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
    
end
