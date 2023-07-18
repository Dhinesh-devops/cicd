class SoldItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_sold_status]
  before_action :authenticate_user!

  def index
  end

  def update_sold_status
    rfid_values = params[:rfid_values].split(',') if params[:rfid_values].present?
    rfid_values.present? && rfid_values.each_with_index do | rfid_value, index |
      stock_item = StockItem.find_by(rfid_number: rfid_value)
      stock_item.update!(status: 2) if stock_item.present? && (stock_item.status != "sold")
    end
    flash[:notice] = 'Updated sold items successfully.'
    redirect_to sold_items_path
  rescue Exception => e
    flash[:error] = "Something went wrong. Please try again."
    redirect_to sold_items_path
  end

end