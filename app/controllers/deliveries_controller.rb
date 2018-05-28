class DeliveriesController < ApplicationController
  
  before_filter :load_deliverable, only: [:create]
  before_action :authenticate_pharmacy!, except: [:show, :download_signature, :pusher, :status, :rx_status, :get_pharmacy,
                                                  :request_delivery, :update_rx_status, :rx_search, :add_new_rx,
                                                  :update_rx_phone_number]
  before_action :check_correct_pharmacy, except: [:status, :update_rx_phone_number, :rx_status, :get_pharmacy, :request_delivery,
                                                  :update_rx_dob]
  
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
      @rxes = Rx.where(pharmacy_id: current_pharmacy.id)
    end
    if @rxes
      if @rxes.count == 1
        @rx = @rxes.last
      end
    end
  end
  
  def dashboard
    @refills = RequestAlert.where(pharm_id: current_pharmacy.id, active: true)
    @deliveries = DeliveryRequest.where(pharmacy_id: current_pharmacy.id, active: true)
    @requests = @refills + @deliveries
  end
  
  def live_requests_dashboard
    @refills = RequestAlert.where(pharm_id: current_pharmacy.id, created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, active: true)
    @deliveries = DeliveryRequest.where(pharmacy_id: current_pharmacy.id, created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, active: true)
    @requests = @refills + @deliveries
    render :layout => false
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
    @refill = RequestAlert.create(pharm_id: @rx.pharmacy_id, rx: @rx.rx, active: true, request_ip: "#{request.remote_ip}")
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
      @rx = Rx.create(rx: rx, pharmacy_id: id, current_status: 'on hold', last_filled_on: DateTime.now)
    end
    render :layout => false
  end
  
  def rx_search
    @rx = Rx.where(pharmacy_id: current_pharmacy.id).search(params[:search])
    @search = params[:search]
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
    render :layout => false
  end
  
  def update_rx_dob
    dob = params[:dob]
    instructions = params[:instructions]
    if instructions == 'undefined'
      instructions = 'no delivery instructions provided'
    end
    rx = params[:rx]
    @rx = Rx.find_by(rx: rx)
    if !@rx.nil?
      @rx.update(dob: dob, delivery_instructions: instructions)
    end
    render :layout => false
  end
  
  def delete_rx
    rx = params[:rx]
    if rx.present?
      @rx = Rx.find_by(rx: rx)
    end
    if !@rx.nil?
      if @rx.pharmacy_id != current_pharmacy.id
        @unauthorized = "You are not authorized to perform this action!"
        @type = 'warning';
        @message = @unauthorized
      else
        @refill = RequestAlert.find_by(pharm_id: current_pharmacy.id, rx: @rx.rx, active: true)
        @delivery = DeliveryRequest.find_by(pharmacy_id: current_pharmacy.id, rx: @rx.rx, active: true)
        if !@refill.nil?
          @refill.update(active: false)
        end
        if !@delivery.nil?
          @delivery.update(active: false)
        end
        @rx.delete
        @type = 'success'
        @message = "Rx ##{@rx.rx} deleted!"
      end
    else
      @error = "An error occurred while removing this rx. Contact us if this problem persists."
      @type = 'danger';
      @message = @error
    end
    pusher.trigger('rx-alert', 'new-rx-alert', {
      message: @message,
      id: @rx.id,
      type: @type,
      rx: @rx.rx,
      pharmacy_id: current_pharmacy.id
    })
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
      @rejected = 'Sorry, the date of birth and address do not match the ones in our records.'
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
  
  def create_notification
    time = params[:time] unless params[:time] == 'none'
    type = params[:type]
    rx = params[:rx]
    pharmacy_id = params[:id]
    if pharmacy_id.to_i != current_pharmacy.id
      return
    end
    @notification = Notification.find_by(rx: rx, active: true, notification_type: type)
    if !@notification.nil?
      render :layout => false
      return
    end
    content_delivery = "A delivery has been requested for rx ##{rx}. Delivery time is #{time}."
    refill_content = "A refill has been requested for rx ##{rx}. Make sure to verify that the rx exists, and update the date of birth."
    if type == 'delivery'
      Notification.create(pharmacy_id: current_pharmacy.id, content: content_delivery, notification_type: "delivery", read: false, rx: rx, active: true)
    elsif type == 'refill'
      Notification.create(pharmacy_id: current_pharmacy.id, content: refill_content, notification_type: "refill", read: false, rx: rx, active: true)
    end
    render :layout => false
  end
  
  def dismiss_notification
    @notification = Notification.find(params[:id])
    @notification.update(read: true, active: false)
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id, read: false)
    render :layout => false
  end
  
  def dismiss_all_notifications
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id, read: false)
    @notifications.each {|n| n.update(read: true, active: false) }
    render :layout => false
  end
  
  def set_invalid_rx
    id = params[:id]
    status = params[:status]
    type = params[:type]
    case type
    when 'refill'
      @request = RequestAlert.find(id)
    when 'delivery'
      @request = DeliveryRequest.find(id)
    end
    if status == 'invalid'
      @rx = Rx.find_by(rx: @request.rx)
      @type = @request.type
      @request.update(active: false, is_valid: false)
      ## Message person who requested rx
      ## phone = @rx.phone
      @rx.delete
    end
    @refills = RequestAlert.where(pharm_id: current_pharmacy.id, created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, active: true)
    @deliveries = DeliveryRequest.where(pharmacy_id: current_pharmacy.id, created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc, active: true)
    @requests = @refills + @deliveries
    render :layout => false
  end
  
  def update_rx_status
    id = params[:id]
    status = params[:status]
    @rx = Rx.find_by(id: id)
    if status == 'deliverySent'
      status = 'sent'
      @rx.update(current_status: status, last_filled_on: DateTime.now, delivery_requested: false)
      @delivery = DeliveryRequest.find_by(rx: @rx.rx)
      if !@delivery.nil?
        @delivery.update(active: false, is_valid: true)
      end
    elsif status == 'refilled'
      @rx.update(current_status: status, last_filled_on: DateTime.now, refill_requested: false)
      @refill = RequestAlert.find_by(rx: @rx.rx)
      if !@refill.nil?
        @refill.update(active: false)
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
    
    def check_correct_pharmacy
      @pharmacy = current_pharmacy
      if @pharmacy.nil?
        redirect_to root_path
      end
    end
    
    def load_deliverable
      resource, id = request.path.split('/')[1, 2]
      @deliverable = resource.singularize.classify.constantize.find(id)
    end
    
    def delivery_params
      params.require(:delivery).permit(:recipient_name, :medications, :copay, :signed_on)
    end
  
end
