class RxesController < ApplicationController
  
  def create
    @batch = Batch.find_by(id: params[:rx][:batch_id])
    @rx = Rx.new(rx_params)
    @rx.pharmacy = current_pharmacy
    @rx.batch = @batch
    respond_to do |format|
      if @rx.save
        @rxes = Rx.where(pharmacy_id: current_pharmacy.id, batch_id: @batch.id)
        # format.html {redirect_to @batch}
        format.js {render layout: false}
      end
    end
  end
  
  def order_prescriptions
    @denied = 1
    rx_list = params[:rx_numbers]
    year = params[:birth_year]
    if Rx.sanitized?(rx_list) == false
      @denied = 0
      render :layout => false
      return
    end
    @confirmation = Rx.generate_confirmation
    rx_list.strip.split(', ').each do |r|
      Rx.create(rx: r, birth_year: year, confirmation: @confirmation.to_s, pharmacy_id: params[:pharmacy_id], current_status: 'received')
    end
    render :layout => false
  end
  
  def track_order
    confirmation = params[:confirmation_number]
    @rxes = Rx.where(confirmation: confirmation)
    statuses = @rxes.map(&:current_status)
    if statuses.include?('processed')
      @status = 'is being processed'
    elsif statuses.include?('picked up')
      @status = 'is on the way'
    else
      @status = 'has been received'
    end
    render :layout => false
  end
  
  private
  
  def rx_params
    params.require(:rx).permit(:rx, :address, :phone_number, :batch_id)
  end
end
