class Api::V1::DataSheetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_login_signature

  #
  # get_daily_sheet_details
  # To get daily sheet details imported by admin
  #
  def get_daily_sheet_details
    if DataSheet.daily_sheet_uploaded?
      response_success('Daily sheet details ready!', 200, ActiveModelSerializers::SerializableResource.new(DataSheet.last, serializer: DataSheetSerializer))
    else
      response_failure('Daily data sheet not uploaded by super admin!', 409)
    end
  rescue Exception => e
    response_failure(e, 500)
  end

  #
  # get_daily_stock_items
  # To get daily stock items by sheet_id imported by admin
  #
  def get_daily_stock_items
    data_sheet = DataSheet.find_by(id: params[:id])
    response_success('Daily stock items data ready!', 200, ActiveModelSerializers::SerializableResource.new(data_sheet.stock_items, each_serializer: StockItemSerializer))
  rescue Exception => e
    response_failure(e, 500)
  end

  #
  # update_stock_status
  # To update stock item status as scanned or missed
  #
  def update_stock_status
    binding.pry
    stock_items = params[:stock_items]
    stock_items.present? && stock_items.each do | stock |
      stock_item = StockItem.find_by(id: stock[:id])
      stock_item.update(status: stock[:status]) if stock_item.present?
    end
    response_success('Stock item status updated!', 200)
  rescue Exception => e
    response_failure(e, 500)
  end
end