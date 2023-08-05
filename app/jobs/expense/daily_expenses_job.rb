class Expense::DailyExpensesJob < ApplicationJob
  queue_as :default
  def perform
    @expenses = Expense.all
    @expenses.each do |expense|
      date = expense.date
      frequency = expense.frequency
      if frequency == "one_time"
        next_occurrence_date = nil
      elsif frequency == "weekly"
        next_occurrence_date = date + 1.week
      elsif frequency == "monthly"
        next_occurrence_date = date + 1.month
      elsif frequency == "alternate_months"
        next_occurrence_date = date + 2.month
      elsif frequency == "quarterly"
        next_occurrence_date = date + 6.month
      elsif frequency == "annually"
        next_occurrence_date = date + 1.year
      elsif frequency == "custom"
        next_occurrence_date = nil
      end
      if next_occurrence_date == Date.today
        new_expense = expense.deep_dup
        new_expense.date = Date.today
        if new_expense.save
          UserMailer.expense_generated(new_expense).deliver_now
        end
      else
        next
      end
    end
  end
end
