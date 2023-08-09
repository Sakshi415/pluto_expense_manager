class IncomeExpenseSerializer
  include JSONAPI::Serializer
  attributes :label, :frequency, :amount, :source, :created_at, :updated_at

  attribute :date do |object|
    object.date.to_date
  end

  attribute :object_type do |object|
    if object.class.name == "Income"
      object.income_type
    elsif object.class.name == "Expense"
      object.expense_type
    end
  end
  
  attribute :class_name do |object|
    object.class.name
  end
end
