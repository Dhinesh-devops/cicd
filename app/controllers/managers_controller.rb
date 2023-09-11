class ManagersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :find_user, only: [:edit, :update, :destroy]

  def index
    @managers = User.managers.order(created_at: :desc)
  end

  def new
  end

  def create
    resource = User.new(user_params)
    resource.save

    if resource.persisted? && resource.errors.empty?
      flash[:notice] = 'Manager created successfully'
      redirect_to managers_path
    else
      flash[:error] = resource.errors.full_messages.to_sentence
      redirect_to new_manager_path
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.record.errors.full_messages.to_sentence
    redirect_to new_manager_path
  rescue Exception => e
    flash[:error] = e.record.errors.full_messages.to_sentence
    redirect_to new_manager_path
  end

  def edit
  end

  def update
    if @manager.update(first_name: params[:first_name], last_name: params[:last_name])
      flash[:notice] = "Manager details updated successfully"
      redirect_to managers_path
    else
      flash[:error] = "Unable to update manager now, please try again"
      redirect_to edit_manager_path(@manager)
    end
  rescue Exception => e
    flash[:error] = e.record.errors.full_messages.to_sentence
    redirect_to edit_manager_path(@manager)
  end

  def destroy
    if @manager.delete
      response_success('Manager deleted successfully.', 200)
    else
      response_failure('Unable to delete manager', 409)
    end
  rescue Exception => e
    response_failure(e, 500)
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email).merge(role_id: 1, password: 'Password@123', password_confirmation: 'Password@123')
  end

  def find_user
    @manager = User.find_by(id: params[:id], role_id: 1)
    redirect_to managers_path, error: "Manager not found" unless @manager.present?
  end
end