class UserPasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token
  protect_from_forgery :except => [:create]
  layout 'devise'

  #
  # new
  # To show forgot/reset password form.
  #
  def new
  end

  #
  # create
  # To send reset password link to email.
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if resource.errors.empty?
      flash[:notice] = 'Email Sent successfully!'
      redirect_to forgot_password_path
    else
      flash[:error] = 'Unknown Email'
      redirect_to forgot_password_path
    end
  end

  #
  # edit
  # To show change password form.
  #
  def edit
  end

  #
  # update
  # To update new password.
  #
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      flash[:notice] = 'New password updated successfully! Log in with your new password.'
      redirect_to root_path
    else
      flash[:error] = resource.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end
end