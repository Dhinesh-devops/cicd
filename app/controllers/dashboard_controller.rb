class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    sheet_uploaded = DataSheet.daily_sheet_uploaded?
    @total_stock_count = sheet_uploaded ? DataSheet.last.stock_items.count : 0
    @scanned_stocks = sheet_uploaded ? "0%" : "0%"
    @missed_stocks = sheet_uploaded ? "0%" : "0%"
    @sold_stocks = sheet_uploaded ? "0%" : "0%"
    @size_wise_stocks = sheet_uploaded ? "0%" : "0%"
    @season_wise_stocks = sheet_uploaded ? "0%" : "0%"
  end
end