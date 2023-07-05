class ApplicationController < ActionController::Base
  before_action :set_cache_buster
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  #
  # response_success
  # this will return the json with success message and data
  #
  def response_success(message, status, data = [])
    json_resp = { message: }
    json_resp['data'] = data
    render json: json_resp, status: status
  end

  #
  # response_failure
  # this will return the json with error message and status
  #
  def response_failure(exception, status, message = nil)
    if (status == 500)
      exception_msg = Rails.env.production? ? "Oops!, Something Went Wrong." : exception.message
    else
      exception_msg = message.present? ? message : exception
    end

    render json: { error: exception_msg }, status: status
  end

  private
  
  def token(user_id)
    payload = { user_id: user_id }
    JWT.encode(payload, hmac_secret, 'HS256')
  end

  def hmac_secret
    # ENV["API_SECRET"]
    'secret'
  end

  def client_has_valid_token?
    !!current_user_id
  end

  def current_user_id
    begin
      token = request.headers["Authorization"].split("Bearer ").last
      decoded_array = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' })
      payload = decoded_array.first
    rescue 
      return nil
    end
    payload["user_id"]
  end

  def require_login_signature
    render json: {error: 'Unauthorized'}, status: :unauthorized if !client_has_valid_token?
  end

  def require_user_logged_in
    if session[:user_id]
      # set current user
      @current_user = User.find_by(id: session[:user_id])
    else
      # allows only logged in user
      redirect_to root_path, notice: 'You must be signed in'
    end
  end
end
