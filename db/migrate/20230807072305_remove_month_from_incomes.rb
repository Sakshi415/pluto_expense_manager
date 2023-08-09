class RemoveMonthFromIncomes < ActiveRecord::Migration[7.0]
  def change
    remove_column :incomes, :month, :date
  end
end
