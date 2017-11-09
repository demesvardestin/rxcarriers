class PatientsController < ApplicationController
    before_filter :load_patable, only: [:index, :show, :create, :destroy, :new, :edit, :update]
    
    def create
        @patient = @patable.patients.new(patient_params)
        @patient.pharmacy = current_pharmacy
        respond_to do |format|
            if @patient.save
                format.html {redirect_to :back}
                format.js {render layout: false}
            end
        end
    end
    
    def destroy
        @patient.destroy
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Pharmacy was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
      
    private
      
        def patient_params
            params.require(:patient).permit(:name, :address, :phone, :note, :copay, :batch_id, :pharmacy_id, :patable_type, :patable_id)
        end
        # Patient Load
        def load_patable
            resource, id = request.path.split('/')[1, 2]
            @patable = resource.singularize.classify.constantize.find(id)
        end
    
end
