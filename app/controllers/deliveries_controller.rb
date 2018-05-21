class DeliveriesController < ApplicationController
  
  before_filter :load_deliverable, only: [:create]
  before_action :check_current_pharmacy, only: [:create, :destroy]
  # before_action :check_current_driver, only: [:edit, :update, :signature]
  before_action :authenticate_pharmacy!, except: [:show, :download_signature, :pusher, :status, :rx_status, :get_pharmacy,
                                                  :request_delivery, :update_rx_status, :rx_search, :add_new_rx,
                                                  :update_rx_phone_number]
  
  def index
    if params["request_rx"]
      @rx = Rx.find_by(rx: params["request_rx"])
    elsif params["request_type"]
      if params["request_type"] == 'delivery'
        @rxes = Rx.where(pharmacy_id: current_pharmacy.id, delivery_requested: true)
      elsif params["request_type"] == 'refill'
        @rxes = Rx.where(pharmacy_id: current_pharmacy.id, refill_requested: true)
      elsif params["request_type"] == 'delivery + refill'
        @rxes = Rx.where(pharmacy_id: current_pharmacy.id, delivery_requested: true, refill_requested: true).all
      end
    else
      @prescriptions = Rx.where(pharmacy_id: current_pharmacy.id)
    end
    if @rxes
      if @rxes.count == 1
        @rx = @rxes.last
      end
    end
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, driver_id: nil)
  end
  
  def dashboard
    @refills = RequestAlert.where(pharm_id: current_pharmacy.id, active: true)
    @deliveries = DeliveryRequest.where(pharmacy_id: current_pharmacy.id, active: true)
    @both = RefillDelivery.where(pharmacy_id: current_pharmacy.id, active: true)
    # if @refills.count > 0 && @deliveries.count > 0 && @both.count > 0
      @requests = @refills + @deliveries + @both
    # elsif @refills.count == 0
    #   @requests = @deliveries
    # elsif @deliveries.count == 0
    #   @requests = @refills
    # end
  end
  
  def status
    # @rx = Rx.search(params[:search])
  end
  
  def update_rx_phone_number
    rx = params[:rx]
    phone = params[:phone]
    @rx = Rx.find_by(rx: rx)
    if @rx.nil?
      return
    end
    @rx.update(phone_number: phone, refill_requested: true)
    @refill = RequestAlert.create(pharm_id: @rx.pharmacy_id, rx: @rx.rx)
    pusher.trigger('new-rx', 'rx-request', {
      message: "New refill request for rx ##{@rx.rx}!",
      id: @rx.id,
      type: 'refill',
      rx: @rx.rx,
      pharmacy_id: @rx.pharmacy_id
    })
    render :layout => false
  end
  
  def rx_status
    id = params[:id]
    rx = params[:rx]
    if id.nil? || rx.nil?
      return
    end
    @rx = Rx.find_by(pharmacy_id: id, rx: rx)
    if @rx.nil?
      @rx = Rx.create(rx: rx, pharmacy_id: id)
    end
    render :layout => false
  end
  
  def rx_search
    @rx = Rx.where(pharmacy_id: current_pharmacy.id).search(params[:search])
    @search = params[:search]
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, driver_id: nil)
    render :layout => false
  end
  
  def get_pharmacy
    name = params[:name].downcase
    npi = params[:npi]
    if npi && name.length == 0
      @pharmacy = Pharmacy.find_by(npi: npi)
    elsif npi.length == 0 && name
      @pharmacies = Pharmacy.search(name)
    elsif name && npi
      @pharma = Pharmacy.find_by(npi: npi)
      @pharmas = Pharmacy.search(name)
      if @pharma.nil?
        @pharmacies = @pharmas
      elsif @pharmas.length == 0
        @pharmacy = @pharma
      elsif !@pharma.nil? && @pharmas.length > 0
        @pharmacy = @pharmas.select { |pharma|
          pharma.id == @pharma.id
        }.last
      end
    end
    render :layout => false
  end
  
  def add_new_rx
    rx = params[:rx]
    phone = params[:phone]
    dob = params[:dob]
    address = params[:address]
    @rx = Rx.create(rx: rx, phone_number: phone, dob: dob, address: address, pharmacy_id: current_pharmacy.id, current_status: 'On hold', last_filled_on: DateTime.now)
    @rxes = Rx.where(pharmacy_id: current_pharmacy.id)
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, driver_id: nil)
    render :layout => false
  end
  
  def request_delivery
    id = params[:id]
    dob = params[:dob]
    time = params[:time]
    address = params[:address]
    @rx = Rx.find_by(id: id)
    if @rx.nil?
      return
    elsif @rx.dob != dob && @rx.address != nil
      @rejected = 'Sorry, this date of birth does not match the one in our records'
    else
      if @rx.address.nil?
        @rx.update(delivery_requested: true, address: address)
      else
        @rx.update(delivery_requested: true)
      end
      @request = DeliveryRequest.create(rx: @rx.rx, rx_id: @rx.id, pharmacy_id: @rx.pharmacy_id, active: true, delivery_time: time)
      pusher.trigger('new-rx', 'rx-request', {
        message: "New delivery request for rx ##{@rx.rx}!",
        id: @rx.id,
        type: 'delivery',
        rx: @rx.rx,
        pharmacy_id: @rx.pharmacy_id,
        time: @request.delivery_time
      })
    end
    render :layout => false
  end
  
  def update_rx_status
    id = params[:id]
    status = params[:status]
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, driver_id: nil)
    @rx = Rx.find_by(id: id)
    if status == 'deliverySent'
      status = 'sent'
      @rx.update(current_status: status, last_filled_on: DateTime.now, delivery_requested: false)
      @delivery = DeliveryRequest.find_by(rx: @rx.rx)
      if !@delivery.nil?
        @delivery.delete
      end
    elsif status == 'refilled'
      @rx.update(current_status: status, last_filled_on: DateTime.now, refill_requested: false)
      @refill = RequestAlert.find_by(rx: @rx.rx)
      if !@refill.nil?
        @refill.delete
      end
    else
      @rx.update(current_status: status, last_filled_on: DateTime.now)
    end
    render :layout => false
  end
  
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
