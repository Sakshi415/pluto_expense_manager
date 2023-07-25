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
    income_params_with_projected = income_params.merge(income_type: 'projected')

    actual_income = current_user.incomes.new(income_params)
    projected_income = current_user.incomes.new(income_params_with_projected)

    if actual_income.save && projected_income.save
      update_future_incomes(actual_income)
      render json: actual_income, status: :created
    else
      errors = actual_income.errors.merge(projected_income.errors)
      render json: errors, status: :unprocessable_entity
    end
  end

  def update
    if @income.update(income_params)
      if @income.actual_income?
        update_future_incomes(@income)
      elsif @income.projected_income?
        update_next_occurrence_for_projected(@income.month)
      end
      render json: @income
    else
      render json: @income.errors, status: :unprocessable_entity
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
        update_next_occurrence_for_projected(projected_income.month, projected_income)
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
    params.require(:income).permit(:label, :month, :source, :frequency, :amount, :income_type)
  end

  def update_future_incomes(income)
    case income.frequency.to_sym
    when :monthly
      update_monthly_incomes(income)
    when :weekly
      update_weekly_incomes(income)
    when :quarterly
      update_quarterly_incomes(income)
    when :annually
      update_annual_incomes(income)
    when :alternate_months
      update_alternate_month_incomes(income)
    else
      # For other frequencies, no need to update future incomes.
      return
    end
  end

  def update_monthly_incomes(income)
    next_occurrence = income.month + 1.month

    while next_occurrence <= Date.today
      update_next_occurrence_for_actual(next_occurrence, income)
      update_next_occurrence_for_projected(next_occurrence, income)
      next_occurrence += 1.month
    end
  end

  def update_weekly_incomes(income)
    next_occurrence = income.month + 1.week

    while next_occurrence <= Date.today
      update_next_occurrence_for_actual(next_occurrence, income)
      update_next_occurrence_for_projected(next_occurrence, income)
      next_occurrence += 1.week
    end
  end

  def update_quarterly_incomes(income)
    next_occurrence = income.month + 3.months

    while next_occurrence <= Date.today
      update_next_occurrence_for_actual(next_occurrence, income)
      update_next_occurrence_for_projected(next_occurrence, income)
      next_occurrence += 3.months
    end
  end

  def update_annual_incomes(income)
    next_occurrence = income.month + 1.year

    while next_occurrence <= Date.today
      update_next_occurrence_for_actual(next_occurrence, income)
      update_next_occurrence_for_projected(next_occurrence, income)
      next_occurrence += 1.year
    end
  end

  def update_alternate_month_incomes(income)
    next_occurrence = income.month + 2.months

    while next_occurrence <= Date.today
      update_next_occurrence_for_actual(next_occurrence, income)
      update_next_occurrence_for_projected(next_occurrence, income)
      next_occurrence += 2.months
    end
  end

  def update_next_occurrence_for_actual(next_occurrence, income)
    next_income = current_user.incomes.find_by(frequency: income.frequency, month: next_occurrence, income_type: 'actual')
    if next_income
      next_income.update(amount: next_income.amount + income.amount)
    else
      current_user.incomes.create(
        label: income.label,
        month: next_occurrence,
        source: income.source,
        frequency: income.frequency,
        amount: income.amount,
        income_type: 'actual'
      )
    end
  end

  def update_next_occurrence_for_projected(next_occurrence, income)
    next_income = current_user.incomes.find_by(frequency: income.frequency, month: next_occurrence, income_type: 'projected')
    if next_income
      next_income.update(amount: next_income.amount + income.amount)
    else
      current_user.incomes.create(
        label: income.label,
        month: next_occurrence,
        source: income.source,
        frequency: income.frequency,
        amount: income.amount,
        income_type: 'projected'
      )
    end
  end
end
