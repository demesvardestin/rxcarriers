class PharmaciesController < ApplicationController
  before_action :set_pharmacy, only: [:update, :destroy]
  before_filter :load_patable, only: [:show]
  before_action :check_current_pharmacy
  
  def edit
    @pharmacy = current_pharmacy
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
    @pharmacy.update(card_token: token, stripe_cus: customer.id)
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
    address = params["street"]
    website = params["website"]
    avatar = params["avatar"]
    current_pharmacy.update!(name: name, number: number, supervisor: supervisor, street: address, website: website, avatar_file_name: avatar)
    @pharmacy = current_pharmacy
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
    
    # Patient load
    def load_patable
      resource, id = request.path.split('/')[1, 2]
      @patable = resource.singularize.classify.constantize.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pharmacy_params
      params.require(:pharmacy).permit(:name, :street, :number, :supervisor, :website, :card_number, 
      :bill_country, :exp_month, :exp_year, :bill_street, :bill_city, :bill_state, :bill_zip, :cvc, :avatar)
    end
end
