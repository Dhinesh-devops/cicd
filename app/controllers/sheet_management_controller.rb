class SheetManagementController < ApplicationController
  before_action :authenticate_user!

  def index
    @data_sheets = DataSheet.all.order(created_at: :desc)
  end
end