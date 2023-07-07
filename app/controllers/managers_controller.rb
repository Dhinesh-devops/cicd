class ManagersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:edit, :update]

  def index
    @managers = User.managers.order(:created_at)
  end

  def new
  end

  def create
    resource = User.new(user_params)
    resource.save

    if resource.persisted? && resource.errors.empty?
      redirect_to new_manager_path, notice: "Manager created successfully" 
    else
      redirect_to new_manager_path, error: "Unable to create manager now, please try again"
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_manager_path, notice: e.record.errors.full_messages.to_sentence
  rescue Exception => e
    redirect_to new_manager_path, notice: e.record.errors.full_messages.to_sentence
  end

  def edit
  end

  def update
    if @manager.update(first_name: params[:first_name], last_name: params[:last_name])
      redirect_to managers_path, notice: "Manager details updated successfully"
    else
      redirect_to edit_manager_path(@manager), notice: "Unable to update manager now, please try again"
    end
  rescue Exception => e
    redirect_to edit_manager_path(@manager), notice: e.record.errors.full_messages.to_sentence
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email).merge(role_id: 1, password: 'password123', password_confirmation: 'password123')
  end

  def find_user
    @manager = User.find_by(id: params[:id], role_id: 1)
    redirect_to managers_path, error: "Manager not found" unless @manager.present?
  end
end