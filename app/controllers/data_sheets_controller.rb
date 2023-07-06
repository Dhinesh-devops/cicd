class DataSheetsController < ApplicationController
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

  private

  # Only allow a list of trusted parameters through.
  def data_sheet_params
    params.require(:data_sheet).permit(:sheet_name, :imported_by)
  end
end