# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  respond_to :json


  def create
    user = User.find_by(email: params[:username])

    if user&.valid_password?(params[:password])
      token = JWT.encode(
        { user_id: user.id, email: user.email, name: user.name },
        Devise.secret_key,
        'HS256'
      )
      render json: { access_token: token, user: user }
    else
      Rails.logger.debug("Invalid login attempt for email: #{params[:username]}")
      render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end

  private

  # def respond_with(resource, _opts = {})
  #   render json: { message: 'Successfully logged in', user: resource }
  # end

  def respond_to_on_destroy
    sign_out current_user
    render json: { status: 'success', message: 'Logout successful' }, status: :ok
  end





    


  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
