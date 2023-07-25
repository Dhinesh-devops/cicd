class DataSheetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update_rfid_number, :delete_data_sheet, :create_stock_items]
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
    if params[:rfid_values].present? && params[:stock_item_ids].present?
      params[:rfid_values].each_with_index do | rfid_value, index |
        stock_item_id = params[:stock_item_ids][index]
        stock_item = StockItem.find_by(id: stock_item_id) if stock_item_id.present?
        stock_item.update!(rfid_number: rfid_value) unless stock_item.sold?
      end
    end
    response_success('RFID numbers updated successfully.', 200, ActiveModelSerializers::SerializableResource.new(DataSheet.last, serializer: RfidCountSerializer))
  rescue Exception => e
    response_failure(e, 500)
  end

  def delete_data_sheet
    DataSheet.active.last.stock_items.update(soft_delete: true)
    if DataSheet.active.last.update(soft_delete: true)
      response_success('Data sheet deleted successfully.', 200)
    else
      response_failure('Unable to delete data sheet', 409)
    end
  rescue Exception => e
    response_failure(e, 500)
  end

  def get_stock_items
    if DataSheet.active.last.present? && DataSheet.active.last.stock_items.present?
      stock_items = DataSheet.active.last.stock_items.order(id: :desc)
    else
      stock_items = []
    end
    response_success("Data ready", 200, stock_items)
  end

  def create_stock_items
    stock = StockItem.new(stock_params)
    if stock_params[:rfid_number].present?
      stock_item = StockItem.find_by(rfid_number: stock_params[:rfid_number])
      stock.rfid_number = "" if stock_item.present?
    end
    if stock.save
      flash[:notice] = 'Stock added successfully.'
      redirect_to new_data_sheet_path
    else
      flash[:error] = 'Unable to add stock'
      redirect_to new_data_sheet_path
    end
  rescue Exception => e
    flash[:error] = "Something went wrong. Please try again."
    redirect_to new_data_sheet_path
  end

  private

  # Only allow a list of trusted parameters through.
  def data_sheet_params
    params.require(:data_sheet).permit(:sheet_name, :imported_by)
  end

  def stock_params
    params.require(:stock_item).permit(:data_sheet_id, :plant, :plant2, :plant3, :retek_class, :retek_subclass, :season, :ean_number, :rfid_number, :variant_size, :style_code, :st_loc, :variant, :mrp, :soh_blocked_stock, :soh_without_blocked_stock, :soh_quantity, :soh_value)
  end
end