class UsersController < ApplicationController
  before_action :set_user, only: [:show, :db_details, :transactions]
  before_action :authenticate_user! # Add this line to ensure user authentication

  def show
    render json: @user
  end

  def db_details
    response_hash = Hash.new
    
    if params[:start_date].present? && params[:end_date].present?
      start_time = params[:start_date].to_time
      end_time = params[:end_date].to_time
    else
      start_time = Time.zone.now.beginning_of_month
      end_time = Time.zone.now
    end
    @incomes = @user.incomes.where(month: start_time..end_time)
    @expenses = @user.expenses.where(date: start_time..end_time)
    total_incomes_amount = @incomes.sum(:amount)
    total_expenses_amount = @expenses.sum(:amount)
    actual_incomes_amount = @incomes.actual.sum(:amount)
    projected_incomes_amount = @incomes.projected.sum(:amount)
    actual_expenses_amount = @expenses.actual.sum(:amount)
    projected_expenses_amount = @expenses.projected.sum(:amount)

    response_hash[:total_incomes_amount] = total_incomes_amount
    response_hash[:total_expenses_amount] = total_expenses_amount
    response_hash[:actual_incomes_amount] = actual_incomes_amount
    response_hash[:projected_incomes_amount] = projected_incomes_amount
    response_hash[:actual_expenses_amount] = actual_expenses_amount
    response_hash[:projected_expenses_amount] = projected_expenses_amount
    response_hash[:incomes] = @incomes
    response_hash[:expenses] = @expenses
    render json: response_hash
  end

  def transactions
    if params[:start_date].present? && params[:end_date].present?
      start_time = params[:start_date].to_time
      end_time = params[:end_date].to_time
    else
      start_time = Time.zone.now.beginning_of_month
      end_time = Time.zone.now
    end
    @incomes = @user.incomes.where(month: start_time..end_time)
    @expenses = @user.expenses.where(date: start_time..end_time)
    if params[:type].present?
      if params[:type] == "income"
        income_and_expenses = @incomes.sort_by(&:created_at)
      elsif params[:type] == "expense"
        income_and_expenses = @expenses.sort_by(&:created_at)
      else
        income_and_expenses = "missing_params"
      end
    else
      income_and_expenses = (@incomes+@expenses).sort_by(&:created_at)
    end
    if income_and_expenses == "missing_params"
      render json: {message: "Params are missing."}, status: :unprocessable_entity
    else
      render json: IncomeExpenseSerializer.new(income_and_expenses).serializable_hash
    end
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

  private

  # def user_params
  #   params.require(:user).permit(:name, :password, :email, :phone_number, :username)
  # end

  def set_user
    @user = User.find(params[:id])
  end
end
  