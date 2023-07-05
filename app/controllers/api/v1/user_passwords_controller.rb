class Api::V1::UserPasswordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery :except => [:create]

  #
  # create
  # To send reset password link to email.
  #
  def create
    resource = User.send_reset_password_instructions(forgot_password_params)
  
    if resource.errors.empty?
      response_success('Email Sent successfully!', 200)
    else
      response_failure('Unknown Email', 409)
    end
  end

  #
  # update
  # To update new password.
  #
  def update
    resource = User.reset_password_by_token(update_password_params)

    if resource.errors.empty?
      response_success('New password updated successfully! Log in with your new password.', 200)
    else
      response_failure(resource.errors.full_messages.to_sentence, 409)
    end
  end

  private

  def forgot_password_params
    params.require(:user).permit(:email)
  end

  def update_password_params
    params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
  end
end