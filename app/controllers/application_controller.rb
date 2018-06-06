class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :redirect_from_cross_model
  # before_action :check_payment_settings
  
  def check_driver_path
    
  end
  
  # def check_payment_settings
  #   @pharmacy = current_pharmacy
  #   if @pharmacy.on_trial.nil? || @pharmacy.on_trial == false || @pharmacy.delinquent == true || @pharmacy.is_subscribed == false || @pharmacy.is_subscribed.nil?
  #     redirect_to choose_subscription_path
  #   end
  # end
  
  
  # def redirect_from_cross_model
  #   url = request.original_url
  #   current_driver = Driver.find_by(firebase_uid: params[:firebase_uid])
  #   if current_pharmacy
  #     if url.include?("courier")
  #       redirect_to authenticated_pharmacy_root_path
  #     end
  #   end
  # end
  
  # def 
  
  def check_current_pharmacy
    redirect_to unauthorized_path unless current_pharmacy
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
