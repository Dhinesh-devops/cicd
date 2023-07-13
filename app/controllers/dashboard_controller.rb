class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    sheet_uploaded = DataSheet.daily_sheet_uploaded?
    stock_items = DataSheet.last.stock_items
    total_count = stock_items.count
    scanned_percent = DataSheet.cal_percent(total_count, stock_items.scanned.count)
    missed_percent = DataSheet.cal_percent(total_count, (total_count - stock_items.scanned.count))
    @total_stock_count = sheet_uploaded ? total_count : 0
    @scanned_stocks = sheet_uploaded ? scanned_percent.round(2).to_s + "%" : "0%"
    @missed_stocks = sheet_uploaded ? missed_percent.round(2).to_s + "%" : "0%"
    @sold_stocks = sheet_uploaded ? "0%" : "0%"
    @size_wise_stocks = sheet_uploaded ? "0%" : "0%"
    @season_wise_stocks = sheet_uploaded ? "0%" : "0%"
  end
end