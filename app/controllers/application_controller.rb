class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  before_action :check_token
  before_action :load_vapid_keys
  
  def check_driver_path
    
  end
  
  def load_vapid_keys
    @vapid_public = 'BKZPPLlOQmgaKAdnJd0ecmY92fB4_0jqJ8PktJqC5rjT9h_arlyzHvzpFBmowIJdnOLgU625bIPw_aA7NdEiej8'
    @vapid_private = 'MsnNhjRXv5ePwAS3yfe2fYCA6HOl7OIX9_uSC9zZKXk'
  end
  
  def check_token
    url = request.original_url
    @token = params[:secure_token]
    if url.include?('pharmacy/signup')
      redirect_to root_path if @token.nil? || !RegistrationRequest.exists?(secure_token: @token)
    end
    @registration = RegistrationRequest.find_by(secure_token: @token)
  end
  
  def check_current_pharmacy
    redirect_to root_path unless current_pharmacy
  end
  
  def check_current_driver
    redirect_to unauthorized_path unless current_driver
  end
  
  def check_authenticated
    redirect_to unauthorized_path unless authenticated_user
  end
  
  def authenticated_user
    current_driver || current_pharmacy
  end
  
  def unauthorized_access
    redirect_to unauthorized_path
  end
  
end
