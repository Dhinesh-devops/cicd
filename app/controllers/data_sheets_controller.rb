class DataSheetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update_rfid_number]
  before_action :authenticate_user!

  def new
    @data_sheet = DataSheet.new
  end

  def create
    if DataSheet.is_valid?(params[:data_sheet][:file])
      data_sheet = DataSheet.new(data_sheet_params)
      data_sheet.file.attach(params[:data_sheet][:file]) if params[:data_sheet][:file].present?
      if data_sheet.save
        ImportDataService.new(data_sheet.file_path, data_sheet.id).process
        flash[:notice] = 'Data sheet uploaded successfully.'
        redirect_to new_data_sheet_path
      else
        flash[:error] = 'Unable to upload data sheet, Please try again.'
        redirect_to new_data_sheet_path
      end
    else
      flash[:error] = 'Invalid data sheet, Please upload valid sheet.'
      redirect_to new_data_sheet_path
    end
  rescue Exception => e
    flash[:error] = "Something went wrong. Please try again."
    redirect_to new_data_sheet_path
  end

  def update_rfid_number
    rfid_existed_values = []
    if params[:rfid_values].present? && params[:stock_item_ids].present?
      params[:rfid_values].each_with_index do | rfid_value, index |
        stock_item_id = params[:stock_item_ids][index]
        stock_item = StockItem.find_by(id: stock_item_id) if stock_item_id.present?
        stock_item_with_same_rfid = StockItem.find_by(rfid_number: rfid_value)
        if stock_item_with_same_rfid.present?
          rfid_existed_values << rfid_value
        else
          stock_item.update!(rfid_number: rfid_value)
        end
      end
    end
    response_success('RFID numbers updated successfully.', 200, ActiveModelSerializers::SerializableResource.new(DataSheet.last, serializer: RfidCountSerializer, rfid_existed_values: rfid_existed_values))
  rescue Exception => e
    response_failure(e, 500)
  end

  def delete_data_sheet
    if DataSheet.last.destroy
      response_success('Data sheet deleted successfully.', 200)
    else
      response_failure('Unable to delete data sheet', 409)
    end
  rescue Exception => e
    response_failure(e, 500)
  end

  private

  # Only allow a list of trusted parameters through.
  def data_sheet_params
    params.require(:data_sheet).permit(:sheet_name, :imported_by)
  end
end