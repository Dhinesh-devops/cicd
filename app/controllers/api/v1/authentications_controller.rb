class Api::V1::AuthenticationsController < ApplicationController
  before_action :require_login_signature, except: :login
  protect_from_forgery :except => [:login]
  respond_to :json

  #
  # login
  # this method checks the login and create the session
  #
  def login
    user = User.find_for_authentication(email: params['user']['email'], role_id: 1)
    if user.present?
      if user.valid_password?(params['user']['password'])
        respond_with user
      else
        response_failure("Login failed", 400)
      end
    else
      response_failure("Invalid email or password", 400)
    end
  rescue ActiveRecord::RecordInvalid => e
    response_failure(e.record.errors.full_messages.to_sentence, 409)  
  rescue Exception => e
    response_failure(e, 500)
  end

  #
  # logout
  # this method checks the token and send success response if user exists
  #
  def logout
    user = User.find_by(id: current_user_id)
    if user.present?
      response_success('Logout successfully', 200)
    else
      response_failure("User not exist with this token", 409)
    end
  end

  private

  #
  # respond_with
  # this method will return the user data with success message
  #
  def respond_with(user)
    # response_success('you are successfully logged in', 200, ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer))
    response_success('you are successfully logged in', 200, token(user.id))
  end
end