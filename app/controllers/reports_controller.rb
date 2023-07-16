class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def get_stock
    if DataSheet.last.present?
      stock_items = DataSheet.get_stock_items(params)
    else
      stock_items = []
    end
    response_success("Data ready", 200, stock_items)
  end

  def download_report
    if DataSheet.last.present?
      send_data DataSheet.to_report_csv(params), filename: "report.csv"
    end
  end
end