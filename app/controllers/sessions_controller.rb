class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  protect_from_forgery :except => [:create]
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
    if user.present?
      auth_options.merge(scope: :user)
      warden.authenticate!(auth_options)

      redirect_to dashboard_path
    else
      redirect_to root_path, notice: 'Invalid email or password'
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, notice: e.record.errors.full_messages.to_sentence
  rescue Exception => e
    redirect_to root_path, notice: e.record.errors.full_messages.to_sentence
  end

  #
  # logout
  # this method destroys the session
  #
  def logout
    sign_out(current_user) if current_user.present?
    redirect_to root_path, notice: 'Logout successful.'
  end
end