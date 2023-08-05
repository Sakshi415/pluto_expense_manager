class Expense < ApplicationRecord
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

  enum expense_type: {
    actual: 'actual',
    projected: 'projected'
  }, _default: 'actual', _suffix: true # This allows you to call actual_income? and projected_income? methods

  scope :actual, -> {where(expense_type: "actual")}
  scope :projected, -> {where(expense_type: "projected")}
end