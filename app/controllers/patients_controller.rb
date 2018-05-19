class PatientsController < ApplicationController
    
    before_action :check_current_pharmacy
    
    def create
        @patient = Patient.new(patient_params)
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
    
    def edit
        @patient = Patient.find(params[:id])
    end
    
    def update
        @patient = Patient.find(params[:id])
        respond_to do |format|
            if @patient.update(patient_params)
               format.html {redirect_to @patient, notice: 'Patient information updated!'} 
            end
        end
    end
    
    def all_patients
        @patient = Patient.new
        @patients = Patient.where(pharmacy_id: current_pharmacy.id).all
    end
    
    def patient_search
        @patients = Patient.where(pharmacy_id: current_pharmacy.id).search(params[:search])
        render :layout => false
    end
    
    def live_search
        @rx = Rx.where(pharmacy_id: current_pharmacy.id).search(params[:search])
        render :layout => false
    end
    
    def create_patient
        name = params["patient-name"]
        address = params["patient-address"]
        phone = params["patient-number"]
        instructions = params["patient-instructions"]
        @patient = Patient.create(name: name, address: address, phone: phone,
                                delivery_instructions: instructions,
                                pharmacy_id: current_pharmacy.id)
        redirect_to customer_path(:id => @patient.id)
    end
    
    def update_patient
        id = params[:id]
        @patient = Patient.find(id)
        if @patient.pharmacy_id != current_pharmacy.id
            return
        end
        name = params["patient-full-name"]
        address = params["patient-address"]
        phone = params["patient-number"]
        instructions = params["patient-instructions"]
        @patient.update(name: name, address: address, phone: phone,
                                delivery_instructions: instructions,
                                pharmacy_id: current_pharmacy.id)
        redirect_to :back
    end
    
    def update_card
      token = params['stripeToken']
      id = params[:id]
      @patient = Patient.find(id)
      if @patient.pharmacy_id != current_pharmacy.id
         return 
      end
      if @patient.stripe_cus
        customer = Stripe::Customer.retrieve(@patient.stripe_cus)
        customer.source = token
        customer.save
      else
        customer = Stripe::Customer.create(
          :description => @patient.name,
          :source => token,
        )
      end
      @patient.update(card_token: token, stripe_cus: customer.id)
      redirect_to :back
    end
    
    def index
        @patient = Patient.new
    end
    
    def disable
        @patient = Patient.find(params[:id])
        @patient.update(disabled: true)
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
            params.require(:patient).permit(:name, :address, :phone, :delivery_instructions)
        end
    
end
