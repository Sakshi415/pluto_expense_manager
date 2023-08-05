class Income::DailyIncomesJob < ApplicationJob
  queue_as :default
  def perform
    @incomes = Income.all
    @incomes.each do |income|
      date = income.month
      frequency = income.frequency
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
        new_income = income.deep_dup
        new_income.month = Date.today
        if new_income.save
          UserMailer.income_generated(new_income).deliver_now
        end
      else
        next
      end
    end
  end
end
