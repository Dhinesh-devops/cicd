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
  # To get daily stock items imported by admin
  #
  def get_daily_stock_items
    stock_items = DataSheet.last.present? ? DataSheet.last.stock_items.except_sold.with_rfid : []
    response_success('Daily stock items data ready!', 200, ActiveModelSerializers::SerializableResource.new(stock_items, each_serializer: StockItemSerializer))
  rescue Exception => e
    response_failure(e, 500)
  end

  #
  # get_report_data
  # To get and return report data
  #
  def get_report_data
    response_success('Report data ready!', 200, ActiveModelSerializers::SerializableResource.new(DataSheet.last, serializer: ReportSerializer))
  rescue Exception => e
    response_failure(e, 500)
  end

  #
  # update_stock_status
  # To update stock item status as scanned or missed
  #
  def update_stock_status
    stock_items = params[:stock_items]
    stock_items.present? && stock_items.each do | stock |
      stock_item = StockItem.find_by(rfid_number: stock[:id])
      stock_item.update(status: stock[:status]) if stock_item.present?
    end
    response_success('Stock item status updated!', 200)
  rescue Exception => e
    response_failure(e, 500)
  end
end