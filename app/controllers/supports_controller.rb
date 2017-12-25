class SupportsController < ApplicationController
  
  before_action :authenticated_user, except: [:unauthorized, :home]
  
  def not_found
    
  end
  
  def home
    
  end
  
  def settings
    
  end
  
  def onboarding_home
    @steps = Support.all
    unless current_driver.onboarding_step_three
      redirect_to :back
    end
  end
  
  def new
    @support = Support.new
  end

  def create
    @support = Support.new(support_params)
    @support.pharmacy = current_pharmacy
    respond_to do |format|
      if @support.save
        format.html {redirect_to :back, notice: "Your question has been submitted. We will be in touch with you very soon."}
      end
    end
  end

  def show
    @support = Support.find(params[:id])
  end
  
  private
    
    def support_params
      params.require(:support).permit(:question_details, :pharmacy_name, :pharmacy_number, :pharmacy_email, :issue_type)
    end
  
end
