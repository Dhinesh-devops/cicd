class DataSheetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update_rfid_number]
  before_action :authenticate_user!

  def new
    @data_sheet = DataSheet.new
  end

  def create
    # if DataSheet.daily_sheet_uploaded?
    #   flash[:error] = 'Daily data sheet already uploaded for today.'
    #   redirect_to new_data_sheet_path
    # else
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
    # end
  rescue Exception => e
    flash[:error] = e.record.errors.full_messages.to_sentence
    redirect_to new_data_sheet_path
  end

  def update_rfid_number
    if params[:rfid_values].present? && params[:stock_item_ids].present?
      params[:rfid_values].each_with_index do | rfid_value, index |
        if (rfid_value != "")
          stock_item_id = params[:stock_item_ids][index]
          stock_item = StockItem.find_by(id: stock_item_id) if stock_item_id.present?
          stock_item.update!(rfid_number: rfid_value)
        end
      end
    end
    response_success('RFID numbers updated successfully.', 200, ActiveModelSerializers::SerializableResource.new(DataSheet.last, serializer: RfidCountSerializer))
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