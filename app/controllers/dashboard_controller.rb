class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    sheet_uploaded = DataSheet.daily_sheet_uploaded?
    if DataSheet.last.present? && DataSheet.last.stock_items.present?
      stock_items = DataSheet.last.stock_items
      total_count = stock_items.count
      scanned_percent = stock_items.present? ? DataSheet.cal_percent(total_count, stock_items.scanned.count) : 0
      missed_percent = stock_items.present? ? DataSheet.cal_percent(total_count, (total_count - stock_items.scanned.count)) : 0
      scanned_count = stock_items.present? ? stock_items.scanned.count : 0
      missed_count = stock_items.present? ? (total_count - stock_items.scanned.count) : 0
    else
      total_count = 0
      scanned_percent = 0
      missed_percent = 0
      scanned_count = 0
      missed_count = 0
    end
    @total_stock_count = total_count
    @scanned_stocks = sheet_uploaded ? scanned_percent.round(2).to_s + "%" : "0%"
    @missed_stocks = sheet_uploaded ? missed_percent.round(2).to_s + "%" : "0%"
    @scanned_stocks_count = sheet_uploaded ? scanned_count : "0"
    @missed_stocks_count = sheet_uploaded ? missed_count : "0"
    @sold_stocks = sheet_uploaded ? "0%" : "0%"
  end

  def reset_password
  end

  def update_new_password
    @user = User.find_by(id: current_user.id)
    current_password = params[:current_password]
    user = User.find_by_email(@user.email)
    if @user && user && user.valid_password?(current_password)
      user.update(password: params[:password])
      sign_in(user, :bypass => true)
      flash[:notice] = "Password successfully changed!"
      redirect_to reset_password_path
    else
      flash[:error] = "Your current password was incorrect. Please try again."
      redirect_to reset_password_path
    end
  end

end