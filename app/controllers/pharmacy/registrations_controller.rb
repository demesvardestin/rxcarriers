class Pharmacy::RegistrationsController < Devise::RegistrationsController
    
    # include Accessible
    # skip_before_action :check_user, only: :destroy
    before_filter :configure_permitted_parameters
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:street, :town, :state, :zipcode, :name, :number, :supervisor, :website])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:street, :town, :state, :zipcode, :identifier, :name])
    end
    
    def after_sign_up_path_for(resource)
        getting_started_path
    end
    
    def after_sign_out_path_for(resource)
        pharmacy_log_in_path 
    end

end