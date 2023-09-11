class Api::V1::UserRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    resource = User.new(sign_up_params)
    resource.role_id = 1
    resource.save

    if resource.persisted? && resource.errors.empty?
      respond_with resource
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def respond_with(resource)
    return response_failure(resource.errors.full_messages.to_sentence, 409) if resource.errors.present?
    response_success('Thanks for Signing up, please login!', 200)
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end