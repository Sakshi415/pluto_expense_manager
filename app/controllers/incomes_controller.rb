class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: [:show, :update, :destroy]

  def index
    incomes = current_user.incomes
    render json: incomes
  end

  def show
    render json: @income
  end

  def create
    begin
      Income.transaction do
        @incomes = current_user.incomes.create!(income_params)
      end
    rescue ActiveRecord::RecordInvalid => exception
      @incomes = {
        error: {
          status: 422,
          message: exception
        }
      }
    end
    render json: @incomes
  end

  def update
    if @income.update(income_params)
      render json: @income
    else
      render json: {message: @income.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @income.destroy
    head :no_content
  end

  def total_amount
    total = current_user.incomes.where(income_type: 'actual').sum(:amount)
    render json: { total_amount: total }
  end
  
  def update_projected_income
    projected_incomes = current_user.incomes.where(income_type: 'projected')
  
    if projected_incomes.update(income_params.permit(:label, :amount, :source))
      projected_incomes.each do |projected_income|
        update_next_occurrence_for_projected(projected_income.date, projected_income)
      end
      render json: { message: 'Projected incomes updated successfully' }, status: :ok
    else
      render json: { error: 'Failed to update projected incomes' }, status: :unprocessable_entity
    end
  end
  
  private

  def set_income
    @income = current_user.incomes.find(params[:id])
  end

  def income_params
    params.permit(income: [:label, :date, :source, :frequency, :amount, :income_type]).require(:income)
  end
end
