class PatientsController < ApplicationController
    
    def create
        @patient = Patient.new(patient_params)
        @patient.pharmacy = current_pharmacy
        respond_to do |format|
            if @patient.save
                format.js {render layout: false}
            end
        end
    end
      
    private
      
        def patient_params
            params.fetch(:patient, {}).require(:name, :address, :phone, :note, :copay, :batch_id, :pharmacy_id, :patable_type, :patable_id)
        end
    
end
