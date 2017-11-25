class PatientsController < ApplicationController
    
    def new
        @patient = Patient.new
    end
    
    def create
        @patient = @patable.patients.new(patient_params)
        @patient.pharmacy = current_pharmacy
        respond_to do |format|
            if @patient.save
                format.html {redirect_to @patient}
                format.js {render layout: false}
            end
        end
    end
    
    def show
        @patient = Patient.find(params[:id])
        @deliveries = Delivery.where(patient_id: @patient.id).all
    end
    
    def index
        @patient = Patient.new
        if params[:search]
          @patients = Patient.where(pharmacy_id: current_pharmacy.id).order("name ASC").search(params[:search])
        else
          @patients = Patient.where(pharmacy_id: current_pharmacy.id).order("name ASC").all
        end
    end
    
    def destroy
        @patient = Patient.find(params[:id])
        @patient.destroy
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Package deleted' }
            format.json { head :no_content }
        end
    end
      
    private
      
        def patient_params
            params.require(:patient).permit(:name, :address, :phone, :note, :copay, :batch_id, :pharmacy_id, :patable_type, :patable_id)
        end
    
end
