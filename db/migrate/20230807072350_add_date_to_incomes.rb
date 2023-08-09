class AddDateToIncomes < ActiveRecord::Migration[7.0]
  def change
    add_column :incomes, :date, :datetime
  end
end
