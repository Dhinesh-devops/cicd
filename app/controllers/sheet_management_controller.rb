class SheetManagementController < ApplicationController
  before_action :authenticate_user!

  def index
    @data_sheets = DataSheet.all.active.order(created_at: :desc)
  end

  def download_sheet
    data_sheet = DataSheet.find_by(id: params[:id])
    File.open(data_sheet.file_path, 'r', binmode: true) do |f|
      send_data f.read, filename: data_sheet.sheet_name,
                        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        disposition: "attachment"
    end
  end

  def delete_sheet
    data_sheet = DataSheet.find_by(id: params[:id])
    if data_sheet.update(soft_delete: true)
      response_success('Datasheet deleted successfully.', 200)
    else
      response_failure('Unable to delete datasheet', 409)
    end
  rescue Exception => e
    response_failure(e, 500)
  end
end