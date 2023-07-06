class Api::V1::DataSheetsController < ApplicationController
  before_action :require_login_signature, except: :login

  #
  # get_daily_sheet_details
  # To get daily sheet details imported by admin
  #
  def get_daily_sheet_details
    response_success('Daily sheet details ready!', 200, ActiveModelSerializers::SerializableResource.new(DataSheet.last, serializer: DataSheetSerializer))
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
end