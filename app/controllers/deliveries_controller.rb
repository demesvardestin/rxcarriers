class DeliveriesController < ApplicationController
  
  before_filter :load_deliverable, only: [:create]
  before_action :check_current_pharmacy, only: [:create, :destroy]
  before_action :check_current_driver, only: [:edit, :update, :signature]
  
  def create_delivery
    name = params["patient_name"]
    address = params['patient_address']
    phone = params['patient_phone']
    copay = params['copay']
    medications = params["medications"]
    @delivery = Delivery.create(
      recipient_name: name,
      recipient_address: address,
      recipient_phone_number: phone,
      medications: medications,
      copay: copay,
      deliverable_type: 'Batch',
      deliverable_id: params['id'],
      pharmacy_id: current_pharmacy.id
    )
    @deliveries = Delivery.where(pharmacy_id: current_pharmacy.id)
    respond_to do |format|
      format.js {}
    end
  end
  
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
    @courier = Courier.find_by(cid: params[:cid])
    @batch = Batch.find_by(driver_id: params[:cid], request_status: 'delivery in progress')
    @delivery = Delivery.find(params[:id])
  end
  
  def download_signature
    token = params[:token]
    id = params[:did]
    head = 'https://firebasestorage.googleapis.com/v0/b/'
    bucket = 'dispenserx-85f34.appspot.com'
    middle = '/o/signatures%2F'
    delivery = 'delivery'+id
    param = '?alt=media&token='+token
    url = head + bucket + middle + delivery + param
    @delivery = Delivery.find(id)
    @batch = Batch.find(@delivery.deliverable_id)
    @delivery.update(signature_image: url, signed_on: DateTime.now, completed: true)
    @batch.update(deliveries_completed: @batch.deliveries_completed + 1)
    if @batch.deliveries.count == @batch.deliveries_completed
      @batch.update_status('completed')
      pusher.trigger('my-channel', 'my-event', {
        message: "Delivery for batch ##{@batch.id} has been completed"
      })
    end
    render :layout => false
  end
  
  def edit
    @delivery = Delivery.find(params[:id])
  end
  
  def signature
    @delivery = Delivery.find(params[:id])
  end
  
  def pusher
    return Pusher::Client.new(
      app_id: "521090",
      key: "6b4730083f66596ec97e",
      secret: "95a0a2107ac2e620e46a",
      cluster: 'us2'
    )
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
