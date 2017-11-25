class SupportsController < ApplicationController
  
  def new
    @support = Support.new
  end

  def create
    @support = Support.new(support_params)
    @support.pharmacy = current_pharmacy
    respond_to do |format|
      if @support.save
        format.html {redirect_to @support, notice: "Your question has been submitted. We will be in touch with you very soon."}
      end
    end
  end

  def show
    @support = Support.find(params[:id])
  end
  
  private
    
    def support_params
      params.require(:support).permit(:question_details)
    end
  
end
