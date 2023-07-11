class SheetManagementController < ApplicationController
  before_action :authenticate_user!

  def index
    @data_sheets = DataSheet.all.order(created_at: :desc)
  end

  def download_report
    send_data DataSheet.to_report_csv(DataSheet.last.id), filename: "report.csv"
  end
end