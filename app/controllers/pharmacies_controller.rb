class PharmaciesController < ApplicationController
  before_action :set_pharmacy, only: [:update, :destroy]
  before_action :check_current_pharmacy, except: [:home, :contact, :blog, :terms,
                :privacy, :press, :search, :search_pharmacy, :show, :create_review,
                :landing, :register_your_pharmacy, :submit_registration_request, :get_current_position, :search_pharmacy_item]
  before_action :check_parameters, only: [:show]
  before_action :check_push_subscription, only: [:dashboard]
  
  def edit
    @pharmacy = current_pharmacy
  end
  
  def landing
    
  end
  
  def get_current_position
    coords = "#{params[:coords][:latitude]}, #{params[:coords][:longitude]}"
    location_object = Geocoder.search(coords)[0].data["address_components"]
    street_number = location_object[0]["long_name"]
    street_name = location_object[1]["long_name"]
    town = location_object[2]["long_name"]
    state = location_object[4]["short_name"]
    zipcode = location_object[6]["long_name"]
    @location = "#{street_number} #{street_name}, #{town} #{state}, #{zipcode}"
    Cart.find_by(shopper_email: guest_shopper.email).update(current_location: @location)
    render :layout => false
  end
  
  def getting_started
    @ticket = HelpTicket.new
    @inventory = Inventory.find_by(pharmacy_id: current_pharmacy.id)
    if @inventory.nil?
      @inventory = Inventory.create(pharmacy_id: current_pharmacy.id)
    end
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id)
    if @notifications.empty?
      Notification.create(pharmacy_id: current_pharmacy.id, content: "We're here to help you increase your OTC sales and retain more customers. To get started, we've set up a few short guides for you, available in: Account > Help. \n\nLet us know if you have any questions!", read: false, title: "Welcome to RxCarriers!")
    end
  end
  
  def notifications
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id)
    @unread = Notification.where(pharmacy_id: current_pharmacy.id, read: false)
  end
  
  def fetch_notification
    notification = params[:notification]
    @notification = Notification.find_by(id: notification[:id])
    @notification.update(read: true)
    render :layout => false
  end
  
  def mark_read
    @notification = Notification.find_by(id: params[:id])
    @notification.update(read: true)
    render :layout => false
  end
  
  def show
    @review = Review.new
    @categories = ItemCategory.all
  end
  
  def analytics
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
  end
  
  def analytics_weekly
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def analytics_monthly
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def analytics_annually
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def analytics_overall
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def create_review
    @pharmacy = Pharmacy.find_by(id: params[:id])
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        format.js {render 'create_review', :layout => false}
      else
        format.js {render 'review_error', :layout => false}
      end
    end
  end
  
  def create_item
    @pharmacy = current_pharmacy
    @item = Item.new(item_params)
    @item.pharmacy_id = current_pharmacy.id
    @item.inventory_id = current_pharmacy.inventory.id
    can_be_taxed = params[:item][:can_be_taxed].downcase
    if can_be_taxed == 'yes'
      taxable = true
    else
      taxable = false
    end
    @item.taxable = taxable
    details = params[:item][:details]
    if details.empty?
      @item.details = 'no description provided'
    end
    @item.active = true
    respond_to do |format|
      if @item.save
        @items = Item.where(pharmacy_id: current_pharmacy.id, active: true).sort_by(&:name)
        format.js {render 'create_item', :layout => false}
      else
        format.js {render 'item_error', :layout => false}
      end
    end
  end
  
  def update_item
    @item = Item.find_by(id: params[:id])
    @item.update(item_params)
    respond_to do |format|
      if @item.save
        @items = Item.where(pharmacy_id: current_pharmacy.id, active: true).sort_by(&:name)
        format.js {render 'update_item', :layout => false}
      else
        format.js {render 'item_error', :layout => false}
      end
    end
  end
  
  def remove_item
    @item = Item.find_by(id: params[:id])
    @item.destroy
    respond_to do |format|
        @items = Item.where(pharmacy_id: current_pharmacy.id, active: true).sort_by(&:name)
        format.js {render 'remove_item', :layout => false}
    end
  end
  
  def make_item_inactive
    @item = Item.find_by(id: params[:id])
    @item.update(active: false)
    respond_to do |format|
        @items = Item.where(pharmacy_id: current_pharmacy.id, active: true).sort_by(&:name)
        format.js {render 'make_item_inactive', :layout => false}
    end
  end
  
  def make_item_active
    @item = Item.find_by(id: params[:id])
    @item.update(active: true)
    respond_to do |format|
        @items = Item.where(pharmacy_id: current_pharmacy.id, active: true).sort_by(&:name)
        format.js {render 'make_item_active', :layout => false}
    end
  end
  
  def billing
    @pharmacy = current_pharmacy
  end
  
  def update_firebase
    firebase_id = params["firebase_id"]
    @pharmacy = current_pharmacy
    @pharmacy.update(firebase_id: firebase_id)
    redirect_to :back
  end
  
  def home
    
  end
  
  def press
    
  end
  
  def privacy
    
  end
  
  def terms
    
  end
  
  def blog
    
  end
  
  def contact
    
  end
  
  def add_card
    token = params['stripeToken']
    @pharmacy = current_pharmacy
    @plan = StripePlan.find_by(pharmacy_id: @pharmacy.id)
    @plan.name == 'beginner' ? plan = 'plan_D0YgQfwIKRVkjx' : plan = 'plan_D0Ygdw4uY8YinB'
    if @pharmacy.stripe_cus
      customer = Stripe::Customer.retrieve(@pharmacy.stripe_cus)
      customer.source = token
      customer.save
    else
      customer = Stripe::Customer.create(
        :email => @pharmacy.email,
        :source => token,
      )
    end
    subscription = Stripe::Subscription.create({
      customer: customer.id,
      items: [{plan: plan}],
      trial_period_days: 7,
    })
    @pharmacy.update(card_token: token, stripe_cus: customer.id, sub_auth: subscription.id)
    render :layout => false
  end
  
  def cancel_subscription
    subscription = Stripe::Subscription.retrieve(current_pharmacy.sub_auth)
    subscription.delete
    current_pharmacy.update(on_trial: false, is_subscribed: false, sub_auth: nil, sub_plan: nil, delinquent: false)
    redirect_to choose_subscription_path
  end
  
  def update_first_time
    sign_in_count = current_pharmacy.sign_in_count + 1
    current_pharmacy.update(sign_in_count: sign_in_count)
    render :layout => false
  end
  
  def search_pharmacy
    @param = params[:q]
    @pharmacies = Pharmacy.sort_search(@param)
    if @pharmacies == 'Invalid location'
      @invalid = @pharmacies
    end
    render :layout => false
  end
  
  def search
    @param = params[:q]
    @pharmacies = Pharmacy.sort_search(@param)
    if @pharmacies == 'Invalid location'
      @invalid = @pharmacies
    end
  end
  
  def dashboard
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, processed: false, status: 'pending', online: true).reverse
  end
  
  def in_store
    @cart = Cart.find_by(pharmacy_id: current_pharmacy.id, pending: true, completed: false, online: false)
    if @cart.nil?
      @cart = Cart.create(pharmacy_id: current_pharmacy.id, pending: true, completed: false, item_list: '', item_list_count: '', instructions_list: '', online: false, total_cost: '0.0')
    end
  end
  
  def register_your_pharmacy
    @registration = RegistrationRequest.new
  end
  
  def submit_registration_request
    @registration = RegistrationRequest.new(registration_params)
    respond_to do |format|
      if @registration.save
        format.js { render :layout => false }
      end
    end
  end
  
  def update_shopper
    data = params[:data]
    @order = Order.find_by(id: data[:order_id])
    message = data[:message]
    render :layout => false
    TwilioPatient.alert_customer(@order.phone_number, message)
    PharmacyMailer.order_in_process(@order).deliver_now
  end
  
  def process_order
    @order = Order.find_by(id: params[:id])
    if @order.nil? || @order.processed == true
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(processed: true, status: 'ready for delivery', delivered: false)
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, processed: false, status: 'pending', online: true)
    @type = 'delivery'
    ## TEXT CUSTOMER ORDER UPDATE
    @pharmacy = Pharmacy.find_by(id: @order.pharmacy_id)
    message = "Good news! Your order is now being prepared by #{@pharmacy.name}."
    TwilioPatient.alert_customer(@order.phone_number, message)
    render :layout => false
  end
  
  def process_pickup_order
    @order = Order.find_by(id: params[:id])
    if @order.nil? || @order.processed == true
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(processed: true, status: 'ready for pickup', delivered: false)
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, processed: false, status: 'pending', online: true)
    ## TEXT CUSTOMER ORDER UPDATE
    @pharmacy = Pharmacy.find_by(id: @order.pharmacy_id)
    message = "Good news! Your order from #{@pharmacy.name} is now ready for pickup!"
    TwilioPatient.alert_customer(@order.phone_number, message)
    render :layout => false
  end
  
  def mark_as_picked_up
    @order = Order.find_by(id: params[:id])
    if @order.nil? || @order.processed == true
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(status: 'picked up', delivered: true)
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, processed: true, status: 'ready for pickup')
    @type = 'pickup'
    ## TEXT CUSTOMER ORDER UPDATE
    @pharmacy = Pharmacy.find_by(id: @order.pharmacy_id)
    message = "Hi there! How would you rate your experience with us?"
    TwilioPatient.alert_customer(@order.phone_number, message)
    render :layout => false
  end
  
  def cancel_order
    @order = Order.find_by(id: params[:id])
    if @order.nil? || (@order.status == 'cancelled' && !@order.refund.nil?)
      # render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @orders = Order.pending
    @type = @order.delivery_option
    @order.process_refund(current_pharmacy)
    Refund.create(
      amount: @order.total,
      order_id: @order.id,
      pharmacy_id: @order.pharmacy_id,
      created_at: Time.zone.now,
      completed: true,
      details: "Store initiated cancelling for order ##{@order.confirmation}",
      stripe_cus: @order.stripe_charge_id,
      connected_account: current_pharmacy.stripe_cus
    )
    ## TEXT CUSTOMER ORDER UPDATE
    @pharmacy = Pharmacy.find_by(id: @order.pharmacy_id)
    message = "Hey there, your order from #{@pharmacy.name} has been cancelled. A refund should be on the way soon."
    TwilioPatient.alert_customer(@order.phone_number, message)
    render :layout => false
  end
  
  def send_for_delivery
    @order = Order.find_by(id: params[:id])
    if @order.nil? || @order.delivered == true
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(processed: true, status: 'delivered', delivered: true)
    @orders = Order.all.where('pharmacy_id = ? AND processed = ? AND delivered = ? AND status != ?', current_pharmacy.id, true, false, 'cancelled')
    ## TEXT CUSTOMER ORDER UPDATE
    @pharmacy = Pharmacy.find_by(id: @order.pharmacy_id)
    message = "Great news! Your order from #{@pharmacy.name} is now on the way. Keep your phone handy, as the courier may attempt to call you upon arrival."
    TwilioPatient.alert_customer(@order.phone_number, message)
    render :layout => false
  end
  
  def post_new_order
    @order = Order.find_by(id: params[:order][:id])
    @pharmacy = Pharmacy.find_by(id: params[:order][:pharmacy_id])
    return if @order.nil? || @pharmacy.nil?
    render :layout => false
  end
  
  def queue
    @pending_pickup_orders = Order.all.where(pharmacy_id: current_pharmacy.id, delivered: false, status: 'ready for pickup', delivery_option: 'pickup').reverse
    @pending_orders = Order.all.where(pharmacy_id: current_pharmacy.id, delivered: false, status: 'ready for delivery', delivery_option: 'delivery').reverse
    @delivered_orders = Order.all.where(pharmacy_id: current_pharmacy.id, delivered: true).reverse
    @cancelled_orders = Order.all.where(pharmacy_id: current_pharmacy.id, status: 'cancelled').reverse
  end
  
  def inventory
    @inventory = Inventory.find_by(pharmacy_id: current_pharmacy.id)
    if @inventory.nil?
      @inventory = Inventory.create(pharmacy_id: current_pharmacy.id)
    end
    @items = current_pharmacy.inventory.items.sort_by(&:name)
    @item = Item.new
  end
  
  def expiring_soon
    @items = Item.expire_soon(current_pharmacy.id).sort_by(&:name)
    render :layout => false
  end
  
  def low_available_count
    @items = Item.low_available_count(current_pharmacy.id).sort_by(&:name)
    render :layout => false
  end
  
  def remove_filters
    @items = current_pharmacy.inventory.items.sort_by(&:name)
    render :layout => false
  end
  
  def search_item
    data = params[:data][:param].split("-").join('')
    @items = current_pharmacy.inventory.items.search(data).sort_by(&:name)
    render :layout => false
  end
  
  def search_pharmacy_item
    data = params[:data][:param].split("-").join('')
    @pharmacy = Pharmacy.find_by(id: params[:data][:pharmacy_id])
    @items = @pharmacy.inventory.items.active.search(data)
    @categories = ItemCategory.all
    render :layout => false
  end
  
  def validate_presence
    data = params[:data][:param].split("-").join('')
    @exists = Item.exists?(pharmacy_id: current_pharmacy.id, ndc: data, active: true)
    render :layout => false
  end
  
  def stripe_callback
    options = {
      site: 'https://connect.stripe.com',
      authorize_url: '/oauth/authorize',
      token_url: '/oauth/token'
    }
    code = params[:code]
    client = OAuth2::Client.new('ca_DQPe1Q3AjkMW0yGMO7N8hwVRU0EAU1Xr', Rails.configuration.stripe[:secret_key], options)
    @resp = client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    @access_token = @resp.token
    current_pharmacy.update(stripe_cus: @resp.params["stripe_user_id"]) if @resp
    redirect_to payment_settings_path
    flash[:notice] = "Your account has been successfully created and is ready to process payments!"
  end
  
  def update_card
    token = params['stripeToken']
    @pharmacy = current_pharmacy
    if @pharmacy.stripe_cus
      customer = Stripe::Customer.retrieve(@pharmacy.stripe_cus)
      customer.source = token
      customer.save
    else
      customer = Stripe::Customer.create(
        :email => @pharmacy.email,
        :source => token,
      )
    end
    if customer.nil?
      redirect_to choose_subscription_path
    end
    @pharmacy.update(card_token: token, stripe_cus: customer.id)
    render :layout => false
  end
  
  def submit_agreement
    @terms_profile = TermsAndAgreement.find_by(pharmacy_id: params[:id])
    if @terms_profile.nil?
      @terms_profile = TermsAndAgreement.create(pharmacy_id: params[:id], signed: true, signed_on: Time.now)
    end
    current_pharmacy.update(is_subscribed: true, on_trial: true)
    render :layout => false
  end
  
  def create
    @pharmacy = Pharmacy.new(pharmacy_params)
    respond_to do |format|
      if @pharmacy.save
        format.html { redirect_to @pharmacy, notice: 'Pharmacy was successfully created.' }
        format.json { render :show, status: :created, location: @pharmacy }
      else
        format.html { render :new }
        format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_profile
    name = params["name"]
    number = params["number"]
    supervisor = params["supervisor"]
    street = params["street"]
    town = params["town"]
    zipcode = params["zipcode"]
    state = params["state"]
    website = params["website"]
    avatar = params["avatar"]
    @pharmacy = current_pharmacy
    @pharmacy.update(pharmacy_params)
    respond_to do |format|
      format.js {}
    end
  end
  
  def push_notifications
    
  end
  
  def push
    subscription_params = params[:data]
    id = subscription_params[:pharmacy_id]
    endpoint = subscription_params[:endpoint]
    p256dh = subscription_params[:p256dh]
    auth = subscription_params[:auth]
    @pharmacy = Pharmacy.find_by(id: id, sub_auth: auth, push_endpoint: endpoint, p256dh: p256dh)
    if @pharmacy.nil? || @pharmacy.subscribed_to_push == false || @pharmacy.subscribed_to_push.nil?
      render :layout => false
      return
    end
    api_key = "AIzaSyDXf3ZfKA7O6Sy-zOvYRDcSGf80fT39b7g"
    Webpush.payload_send(
      message: "New order request!",
      endpoint: "https://fcm.googleapis.com/fcm/send/" + @pharmacy.push_endpoint[48..-1],
      p256dh: @pharmacy.p256dh,
      auth: @pharmacy.sub_auth,
      api_key: api_key
      # vapid: {
      #   subject: 'Test notification',
      #   public_key: @vapid_public,
      #   private_key: @vapid_private
      # }
    )
    render :layout => false
  end
  
  def unsubscribe
    current_pharmacy.update(subscribed_to_push: false, push_endpoint: nil, sub_auth: nil, p256dh: nil)
    render :layout => false
  end
  
  def store_push_endpoint
    @sub = JSON.parse(JSON.dump(params.fetch(:sub, {}))).with_indifferent_access
    endpoint = @sub["endpoint"]
    auth = @sub["keys"]["auth"]
    p256dh = @sub["keys"]["p256dh"]
    current_pharmacy.update(push_endpoint: endpoint, sub_auth: auth, p256dh: p256dh, subscribed_to_push: true)
  end
  
  def update
    @pharmacy.update(pharmacy_params)
    respond_to do |format|
      format.js { render 'pharmacies/update_profile', notice: 'Profile updated!' }
    end
  end
  
  def destroy
    @pharmacy.destroy
    respond_to do |format|
      format.html { redirect_to pharmacies_url, notice: 'Pharmacy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacy
      @pharmacy = Pharmacy.find(params[:id])
    end
    
    def check_parameters
      name = params[:name]
      id = params[:id]
      if name.blank? || id.blank?
        redirect_to :back
      end
      @pharmacy = Pharmacy.find_by(id: id)
      if @pharmacy.nil?
        redirect_to :back
      end
      # @location = Cart.find_by(shopper_email: guest_shopper.email).current_location
      if params[:q]
        @location = params[:q]
        # distance = @pharmacy.unslug(params[:q])
      else
        @location = request.location.latitude.to_s + ', ' + request.location.longitude.to_s
      end
      @distance = @pharmacy.distance_to(@location)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :price, :quantity, :details, :size, :size_type, :ndc, :expiration, :item_category_id, :can_be_taxed)
    end
    
    def registration_params
      params.require(:registration_request).permit(:pharmacy_name, :pharmacy_email, :pharmacy_address, :pharmacy_phone, :pharmacy_manager, :pharmacy_website)
    end
    
    def pharmacy_params
      params.require(:pharmacy).permit(:name, :street, :number, :supervisor, :website, :card_number, 
      :town, :state, :zipcode, :avatar, :hours, :delivers, :saturday, :sunday, :opening_weekday, :closing_weekday, :opening_saturday, :closing_saturday,
      :opening_sunday, :closing_sunday)
    end
end
