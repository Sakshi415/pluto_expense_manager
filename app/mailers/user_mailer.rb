class UserMailer < ApplicationMailer
  default :from => "pluto@expensemanager.com"

  def password_reset_email(user)
    @name = user.name  || user.email
    @reset_password_token = user.reset_password_token
    mail(to: user.email, subject: "Your password needs to reset.")
  end

  def testing_schedular(user)
    @msg = "Testing schedular success. Please ignore this mail."
    mail(to: user.email, subject: "Testing Email.")
  end

  def income_generated(income)
    @income = income
    @user = income.user
    mail(to: @user.email, subject: "Income Generated for #{@income.date.strftime("%d %b %Y")}.")
  end

  def expense_generated(expense)
    @expense = expense
    @user = expense.user
    mail(to: @user.email, subject: "Expense Generated for #{@expense.date.strftime("%d %b %Y")}.")
  end
end
  
