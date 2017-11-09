class RequestsController < ApplicationController
    
    def index
        @requests = Request.where(pharmacy_id: current_pharmacy.id).all
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
    
    def update
    end
    
    def destroy
    end
    
    private
    
    def request_params
        params.fetch(:request, {}).require(:patients, :batch_id, :count, :driver, :status, :body)
    end
    
end
