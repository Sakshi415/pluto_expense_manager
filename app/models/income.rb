class Income < ApplicationRecord
    belongs_to :user
  
    enum frequency: {
      monthly: 'monthly',
      weekly: 'weekly',
      quarterly: 'quarterly',
      annually: 'annually',
      one_time: 'one_time',
      alternate_months: 'alternate_months',
      custom: 'custom'
    }
  
    enum income_type: {
      actual: 'actual',
      projected: 'projected'
    }, _default: 'actual', _suffix: true # This allows you to call actual_income? and projected_income? methods
  
    def calculate_income_and_update_next_occurrence
      case frequency.to_sym
      when :monthly
        income_for_month(Date.today)
      when :weekly
        income_for_week(Date.today)
      when :quarterly
        income_for_quarter(Date.today)
      when :annually
        income_for_year(Date.today)
      when :one_time
        amount
      when :alternate_months
        income_for_alternate_months(Date.today)
      when :custom
        amount
      end
    end
  
    def income_for_month(date)
      next_occurrence = month + 1.month
      while next_occurrence.day != month.day
        next_occurrence += 1.day
      end
      update_next_occurrence_for_actual(next_occurrence)
      amount
    end
  
    def income_for_week(date)
      next_occurrence = month + 1.week
      while next_occurrence.day != month.day
        next_occurrence += 1.day
      end
      update_next_occurrence_for_actual(next_occurrence)
      amount
    end
  
    def income_for_quarter(date)
      next_occurrence = month + 3.months
      while next_occurrence.day != month.day
        next_occurrence += 1.day
      end
      update_next_occurrence_for_actual(next_occurrence)
      amount
    end
  
    def income_for_year(date)
      next_occurrence = month + 1.year
      while next_occurrence.day != month.day
        next_occurrence += 1.day
      end
      update_next_occurrence_for_actual(next_occurrence)
      amount
    end
  
    def income_for_alternate_months(date)
      next_occurrence = month + 2.months
      next_occurrence += 1.month while next_occurrence.day != month.day
      update_next_occurrence_for_actual(next_occurrence)
      amount
    end
  
    def update_next_occurrence_for_actual(next_occurrence)
      next_income = user.incomes.find_by(frequency: frequency, month: next_occurrence, income_type: 'actual')
      if next_income
        next_income.update(amount: next_income.amount + amount)
      else
        current_user.incomes.create(
          label: label,
          month: next_occurrence,
          source: source,
          frequency: frequency,
          amount: amount,
          income_type: 'actual'
        )
      end
    end
end
  