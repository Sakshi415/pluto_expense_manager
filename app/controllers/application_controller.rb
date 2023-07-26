class ApplicationController < ActionController::API

    def authenticate_user!
      token = request.headers['Authorization']&.split(' ')&.last
      decoded_token = JWT.decode(token, Devise.secret_key, true, algorithm: 'HS256')
      user_id = decoded_token[0]['user_id']
      @current_user = User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
end
  