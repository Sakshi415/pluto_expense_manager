class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes do |t|
      t.references :user, foreign_key: true
      t.string :label
      t.date :month
      t.string :source
      t.string :frequency
      t.decimal :amount
      t.string :income_type #, default: "actual" # Set default value to "actual"
      t.timestamps
    end
  end
end
