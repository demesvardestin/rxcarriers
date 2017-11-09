class Pharmacy::RegistrationsController < Devise::RegistrationsController
    
    include Accessible
    skip_before_action :check_user, only: :destroy
    before_filter :configure_permitted_parameters
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:street, :town, :state, :zipcode, :identifier, :name])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:street, :town, :state, :zipcode, :identifier, :name])
    end
    
    def after_sign_up_path_for(resource)
        batches_path
    end

end