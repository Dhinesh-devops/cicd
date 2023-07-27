class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  protect_from_forgery :except => [:create]
  before_action :check_login, only: [:new]
  layout 'devise'

  #
  # new
  # this method will show login page
  #
  def new
  end

  #
  # create
  # this method checks the web login and create the session
  #
  def create
    user = User.find_by(email: params['user']['email'], role_id: 2)
    if user.present? && user.valid_password?(params['user']['password'])
      auth_options.merge(scope: :user)
      warden.authenticate!(auth_options)

      redirect_to dashboard_path
    else
      flash[:error] = 'Invalid email or password'
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.record.errors.full_messages.to_sentence
    redirect_to root_path
  rescue Exception => e
    flash[:error] = "Something went wrong. Please try again."
    redirect_to root_path
  end

  #
  # logout
  # this method destroys the session
  #
  def logout
    sign_out(current_user) if current_user.present?
    redirect_to root_path, notice: 'Logout successful.'
  end

  private

  def check_login
    if current_user.present?
      redirect_to dashboard_path
    end
  end
end