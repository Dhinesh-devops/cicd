class SoldItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_sold_status]
  before_action :authenticate_user!

  def index
  end

  def update_sold_status
    errors = []
    updated_items = []
    rfid_values = params[:rfid_values].split(',') if params[:rfid_values].present?
    rfid_values.present? && rfid_values.each_with_index do | rfid_value, index |
      stock_item = StockItem.find_by(rfid_number: rfid_value)
      if stock_item.present?
        if (stock_item.status != "sold")
          stock_item.update!(status: 2)
        else
          updated_items << rfid_value
        end
      else
        errors << rfid_value
      end
    end
    if errors.present? && updated_items.present?
      flash[:error] = 'Stock is not present with these RFID numbers ' + errors.uniq.to_sentence + ', ' + 'Stock already updated as Sold with these RFID numbers ' + updated_items.uniq.to_sentence
      redirect_to sold_items_path
    elsif errors.present?
      flash[:error] = 'Stock is not present with these RFID numbers ' + errors.uniq.to_sentence
      redirect_to sold_items_path
    elsif updated_items.present?
      flash[:error] = 'Stock already updated as Sold with these RFID numbers ' + updated_items.uniq.to_sentence
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