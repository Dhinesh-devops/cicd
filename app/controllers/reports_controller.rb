class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @stock_items = DataSheet.last.present? ? DataSheet.last.stock_items : []
  end
end