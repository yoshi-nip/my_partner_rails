class CreateMonthlyPromises < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_promises do |t|
      t.date :month
      t.string :body
      t.string :if_then_plan
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
