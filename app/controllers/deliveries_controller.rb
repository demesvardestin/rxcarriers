class DeliveriesController < ApplicationController
  
  before_filter :load_deliverable, only: [:create]
  before_action :check_current_pharmacy, only: [:create, :destroy]
  before_action :check_current_driver, only: [:show, :edit, :update, :signature]
  
  def create
    @delivery = @deliverable.deliveries.new(delivery_params)
    @delivery.pharmacy = current_pharmacy
    @patient = Patient.find(params[:delivery][:recipient_name])
    respond_to do |format|
      if @delivery.save
        @delivery.update(
          patient_id: params[:delivery][:recipient_name].to_i,
          recipient_name: @patient.name,
          recipient_phone_number: @patient.phone,
          recipient_address: @patient.address
        )
        format.html {redirect_to :back, notice: "Package added!"}
      end
    end
  end
  
  def show
    @delivery = Delivery.find(params[:id])
    @pharmacy = Pharmacy.find(@delivery.pharmacy_id)
  end
  
  def edit
    @delivery = Delivery.find(params[:id])
  end
  
  def signature
    @delivery = Delivery.find(params[:id])
  end

  def update
    @delivery = Delivery.find(params[:id])
    @delivery.signed_on = DateTime.now
    respond_to do |format|
      if @delivery.update(delivery_params)
        Batch.delivery_completed(@delivery.deliverable.driver)
        format.html {redirect_to :back, notice: "Package info updated!"}
      end
    end
  end

  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy
    redirect_to :back, notice: "Package deleted!"
  end
  
  private
    
    def load_deliverable
      resource, id = request.path.split('/')[1, 2]
      @deliverable = resource.singularize.classify.constantize.find(id)
    end
    
    def delivery_params
      params.require(:delivery).permit(:recipient_name, :medications, :copay, :signed_on)
    end
  
end
