class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    expenses = current_user.expenses
    render json: expenses
  end

  def show
    render json: @expense
  end

  def create
    begin
      Expense.transaction do
        @expenses = current_user.expenses.create!(expense_params)
      end
    rescue ActiveRecord::RecordInvalid => exception
      @expenses = {
        error: {
          status: 422,
          message: exception
        }
      }
    end
    render json: @expenses
  end

  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: {message: @expense.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end
  
  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def expense_params
    params.permit(expense: [:label, :date, :source, :frequency, :amount, :expense_type, :category, :status]).require(:expense)
  end
end
