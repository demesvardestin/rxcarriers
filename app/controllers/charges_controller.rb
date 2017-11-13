class ChargesController < ApplicationController
    
    def stripe
        unless current_driver.stripe_uid
            options = {
              site: 'https://connect.stripe.com',
              authorize_url: '/oauth/authorize',
              token_url: '/oauth/token'
            }
            code = params[:code]
            client = OAuth2::Client.new(Rails.application.secrets.stripe_publishable_key, Rails.application.secrets.stripe_secret_key, options)
            @resp = client.auth_code.get_token(code, :params => {:scope => 'read_write'})
            @access_token = @resp.token
            Driver.find(current_driver.id).update!(stripe_uid: @resp.params["stripe_user_id"]) if @resp
            flash[:notice] = "You are now ready to receive payments!"
        end
    end
    
    def transactions
        
    end
    
    def create
        @initial_charge = Charge.new(charge_params.merge(email: params["stripeEmail"], card_token: params["stripeToken"]))
        @initial_charge.pharmacy = current_pharmacy
        @initial_charge.blank_charge(@initial_charge.pharmacy)
        respond_to do |format|
            if @initial_charge.save
                format.html {redirect_to :back, notice: "Payment information saved!"}   
            end
        end
    end
    
    private
    
        def charge_params
            params.require(:charge).permit(:description) 
        end
    
end