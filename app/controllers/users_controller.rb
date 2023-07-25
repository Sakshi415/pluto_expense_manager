class UsersController < ApplicationController
    # before_action :set_user, only: [:show, :update, :destroy]
    before_action :authenticate_user! # Add this line to ensure user authentication

    def show
      render json: current_user
    end
  
  
    # def index
    #   @users = User.all
    #   render json: @users
    # end
  
    # def show
    #   render json: @user
    # end
  
    # def create
    #   @user = User.new(user_params)
  
    #   if @user.save
    #     render json: @user, status: :created
    #   else
    #     render json: @user.errors, status: :unprocessable_entity
    #   end
    # end
  
    # def update
    #   if @user.update(user_params)
    #     render json: @user
    #   else
    #     render json: @user.errors, status: :unprocessable_entity
    #   end
    # end
  
    # def destroy
    #   @user.destroy
    #   render json: { message: 'User deleted successfully' }
    # end
  
    # private
  
    # def user_params
    #   params.require(:user).permit(:name, :password, :email, :phone_number, :username)
    # end
  
    # def set_user
    #   @user = User.find(params[:id])
    # end
end
  