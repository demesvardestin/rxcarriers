class RequestsController < ApplicationController
    
    before_action :authenticate_pharmacy!
    
    def index
        if params[:search]
          @requests = Request.where(pharmacy_id: current_pharmacy.id).search(params[:search])
        else
          @requests = Request.where(pharmacy_id: current_pharmacy.id).all
        end
    end
    
    def show
        @request = Request.find(params[:id]) 
    end
    
    def create
        @request = Request.new(request_params)
        @request.pharmacy = current_pharmacy
        respond_to do |format|
            if @request.save
                format.js {render layout: false}
            else
                format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
            end
        end
    end
    
    def cancel
        @request = Request.find(params[:id])
        @request.update!(status: 'cancelled')
        Driver.pharmacy_cancelled(@request.driver, @request.pharmacy_id)
        respond_to do |format|
            format.html {redirect_to :back, notice: "Request has been cancelled. Driver will be notified"} 
        end
    end
    
    def update
    end
    
    def destroy
    end
    
    private
    
    def request_params
        params.fetch(:request, {}).require(:patients, :batch_id, :count, :driver, :status, :body)
    end
    
end
