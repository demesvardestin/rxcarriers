class DriversController < ApplicationController
  before_action :check_verified, except: [:register, :onboarding_address, :onboarding_agreement, :fetch_driver]
  before_action :set_driver, only: [:edit, :update]
  before_action :authenticate_driver!, only: [:deliveries, :accept_request]
  
  def register
    
  end
  
  def edit
    
  end
  
  def update
    @driver.update(driver_params)
    respond_to do |format|
      format.html {redirect_to :back, notice: 'details saved!'}
    end
  end
  
  def fetch_driver
    driver_id = params[:driver_id].to_i
    batch_id = params[:batch_id]
    Batch.find(batch_id).update(driver_id: driver_id, request_status: 'accepted')
    @driver = Driver.find(driver_id)
    # @request = RequestAlert.new(request_details)
    # @request.save!
    respond_to do |format|
      format.json {}
    end
  end
  
  def onboarding_address
    
  end
  
  def onboarding_agreement
    
  end
  
  def show
    @driver = current_driver
  end
  
  def earnings
    @batches = Batch.where(driver_id: current_driver.id).all
    @batches_week = Batch.week_earnings(current_driver.id)
  end
  
  def deliveries
    @courier = Courier.find_by(cid: params[:cid])
    @batch = Batch.find_by(driver_id: current_driver.id, accepted: true, delivered: nil)
    if @batch
      @pharmacy = Pharmacy.find(@batch.pharmacy_id)
    end
  end
  
  def store_push_endpoint
    @sub = JSON.parse(JSON.dump(params.fetch(:sub, {}))).with_indifferent_access
    endpoint = @sub["endpoint"]
    auth = @sub["keys"]["auth"]
    p256dh = @sub["keys"]["p256dh"]
    current_driver.update(push_endpoint: endpoint, sub_auth: auth, p256dh: p256dh, subscribed_to_push: true)
  end
  
  def unsubscribe
    driver = current_driver
    driver.update(subscribed_to_push: nil, push_endpoint: nil, sub_auth: nil, p256dh: nil)
    return
  end
  
  def send_push
    # driver_id = params[:id] || Driver.last.id
    text = params[:details]
    batch_id = params[:batch]
    pharmacy_id = params[:pharmacy]
    @driver = Driver.last
    data = params.fetch(:data, {})
    data["driver"] = @driver.id
    data = JSON.dump(data)
    endpoint = @driver.push_endpoint
    p256dh = @driver.p256dh
    auth = @driver.sub_auth
    api_key = "#{Rails.application.secrets.google_api_key}"
    vapid = {
      subject: 'mailto:sender@example.com',
      public_key: "#{Rails.application.secrets.vapid_public}",
      private_key: "#{Rails.application.secrets.vapid_private}"
    }
    Webpush.payload_send(message: "#{data}",
                    endpoint: endpoint, p256dh: p256dh, auth: auth, vapid: vapid)
  end
  
  def unavailable_request
    
  end
  
  def accept_request
    batch = params[:batch_id]
    @batch = Batch.find_by(id: batch)
    if batch.nil? || @batch.nil?
      redirect_to unavailable_request_path
      return
    elsif @batch.driver_id != nil
      redirect_to unavailable_request_path
    # elsif params[:driver_id] != current_driver.id
    #   redirect_to unavailable_request_path
    else
      if current_driver
        @batch.update(request_status: 'accepted', driver_id: current_driver.id, accepted: true)
        redirect_to courier_deliveries_path(:request_id => @batch.request_id, :driver_id => current_driver.id, :batch_id => @batch.id)
      end
    end
  end
  
  def update_courier
    @courier = current_driver
    @courier.update(driver_params)
    render :layout => false
  end
  
  def update_courier_bank
    token = params[:bank_token]
    if current_driver.stripe_uid
      customer = Stripe::Customer.retrieve(current_driver.stripe_uid)
      customer.source = token
      customer.save
    else
      customer = Stripe::Customer.create(
        :email => current_driver.email,
        :source => token,
      )
    end
    current_driver.update(stripe_token: token, stripe_uid: customer.id)
    render :layout => false
  end
  
  def get_user
    redirect_to "/courier/profile?cid=#{params[:cid]}"
  end
  
  def profile
    
  end
  
  def not_found
    
  end
  
  def unauthorized
    
  end

  private
    
    def set_driver
      @driver = Driver.find(params[:id])
    end
    
    def check_verified
      @courier = Courier.find_by(cid: params[:cid])
      if @courier != nil && @courier.verified.nil?
        # redirect_to "/onboarding/#{@courier.onboarding_step?}"
      end
    end
    
    # make sure the correct driver is authed
    def check_driver
      @driver = current_driver
      redirect_to unauthorized_path, notice: "Not authorized to access this page" if @driver.nil?
    end
    
    # params whitelist
    def driver_params
      params.require(:driver).permit(:first_name, :avatar, :number, :address, :firebase_uid, :cid, :car_make, :car_model, :car_year, :car_color, :license_plate)
    end
end
