class SoldItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_sold_status]
  before_action :authenticate_user!

  def index
  end

  def update_sold_status
    errors = []
    rfid_values = params[:rfid_values].split(',') if params[:rfid_values].present?
    rfid_values.present? && rfid_values.each_with_index do | rfid_value, index |
      stock_item = StockItem.find_by(rfid_number: rfid_value)
      if stock_item.present?
        stock_item.update!(status: 2) if (stock_item.status != "sold")
      else
        errors << rfid_value
      end
    end
    if errors.present?
      flash[:error] = 'Stock is not present with these RFID numbers ' + errors.uniq.to_sentence
      redirect_to sold_items_path
    else
      flash[:notice] = 'Updated sold items successfully.'
      redirect_to sold_items_path
    end
  rescue Exception => e
    flash[:error] = "Something went wrong. Please try again."
    redirect_to sold_items_path
  end

end