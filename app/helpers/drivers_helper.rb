module DriversHelper
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def find_batch(id)
        @batch = Batch.find(id) 
    end
end
