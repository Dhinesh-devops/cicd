class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if DataSheet.last.present? && DataSheet.last.stock_items.present?
      total_count, scanned_percent, missed_percent, scanned_count, missed_count, sold_percent, sold_count = DataSheet.calc_count
    else
      total_count, scanned_percent, missed_percent, scanned_count, missed_count, sold_percent, sold_count = 0, 0, 0, 0, 0, 0, 0
    end
    @total_stock_count = total_count
    @scanned_stocks = scanned_percent.round(2).to_s + "%"
    @missed_stocks = missed_percent.round(2).to_s + "%"
    @scanned_stocks_count = scanned_count
    @missed_stocks_count = missed_count
    @sold_stocks = sold_percent.round(2).to_s + "%"
    @sold_stocks_count = sold_count
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