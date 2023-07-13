class Api::V1::ResetPasswordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_login_signature

  #
  # update_new_password
  # To update new password.
  #
  def update_new_password
    @user = User.find_by(id: current_user_id)
    current_password = params[:current_password]
    user = User.find_by_email(@user.email)
    if @user && user && user.valid_password?(current_password)
      user.update(password: params[:password])
      response_success("Password successfully changed!", 200)
    else
      response_failure("Your current password was incorrect. Please try again.", 409)
    end
  rescue Exception => e
    response_failure(e, 500)
  end

end