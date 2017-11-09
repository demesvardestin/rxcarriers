module BatchesHelper
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def find_request(id)
        @request = Request.find_by(batch_id: id)
        begin
            @request.status
        rescue
            'n/a'
        end
    end
    
end
