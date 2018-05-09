class InvoicesController < ApplicationController
  
  before_action :unauthorized_access, only: [:create]
  before_action :check_current_pharmacy
  
  def index
    @invoices = Invoice.where(pharmacy_id: current_pharmacy.id).paginate(:page => params[:page], :per_page => 10)
    @pharmacy = current_pharmacy
  end
  
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.pharmacy = current_pharmacy
    if @invoice.save
      respond_to do |format|
        format.json { render :show, status: :created, location: @invoice }
      end
    end
  end
  
  def show
    @invoice = Invoice.find(params[:id])
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.delete
    respond_to do |format|
      format.html {redirect_to transactions_path}
    end
  end
  
end
