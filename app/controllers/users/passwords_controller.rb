# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController

  

  def forgot
    if params[:user][:email].blank? # check if email is present
      return render json: { error: 'Email is not present' }
    end
  
    user = User.find_by(email: params[:user][:email]) # if present find user by email
  
    if user.present?
      generated_token = user.generate_password_token!
      user.save # generate pass token
      UserMailer.password_reset_email(user).deliver # send the password reset email
      render json: {token: generated_token,  status: 'ok' }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end
  


  
  def reset
    token = params[:user][:token].to_s

    if params[:user][:email].blank?
      return render json: {error: 'Token not present'}
    end

    user = User.find_by(reset_password_token: params[:user][:token].to_s)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: {status: 'ok'}, status: :ok
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
    end
  end
  # # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end

  # protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end
