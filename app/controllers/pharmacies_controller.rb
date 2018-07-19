class PharmaciesController < ApplicationController
  before_action :set_pharmacy, only: [:update, :destroy]
  before_action :check_current_pharmacy, except: [:home, :contact, :blog, :terms,
                :privacy, :press, :search, :search_pharmacy, :show, :create_review,
                :landing]
  before_action :check_parameters, only: [:show]
  
  def edit
    @pharmacy = current_pharmacy
  end
  
  def landing
    
  end
  
  def show
    @review = Review.new
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
    @location = params[:location]
    @pharmacies = Pharmacy.search_nearby(@location)
    if @pharmacies == 'Invalid location'
      @invalid = @pharmacies
    end
    render :layout => false
  end
  
  def search
    @location = params[:location]
    @pharmacies = Pharmacy.search_nearby(@location)
    if @pharmacies == 'Invalid location'
      @invalid = @pharmacies
    end
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
      distance = @pharmacy.unslug(params[:original_location])
      @distance = @pharmacy.distance_to(distance)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:content, :pharmacy_id)
    end
    def pharmacy_params
      params.require(:pharmacy).permit(:name, :street, :number, :supervisor, :website, :card_number, 
      :town, :state, :zipcode, :avatar, :hours, :delivers)
    end
end
