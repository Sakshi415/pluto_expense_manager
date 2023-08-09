class DailyIncomeJob < ApplicationJob
  queue_as :default
  def perform
    user = User.last
    UserMailer.testing_schedular(user).deliver_now
  end
end