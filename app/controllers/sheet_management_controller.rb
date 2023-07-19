class SheetManagementController < ApplicationController
  before_action :authenticate_user!

  def index
    @data_sheets = DataSheet.all.order(created_at: :desc)
  end

  def download_sheet
    data_sheet = DataSheet.find_by(id: params[:id])
    File.open(data_sheet.file_path, 'r', binmode: true) do |f|
      send_data f.read, filename: data_sheet.sheet_name,
                        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        disposition: "attachment"
    end
  end
end