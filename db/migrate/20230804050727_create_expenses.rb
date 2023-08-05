class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :user, foreign_key: true
      t.string :label
      t.datetime :date
      t.string :source
      t.string :frequency
      t.decimal :amount
      t.string :expense_type
      t.string :category
      t.string :status
      t.timestamps
    end
  end
end
