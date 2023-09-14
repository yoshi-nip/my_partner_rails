class CreateHabitRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :habit_records do |t|
      t.date :date
      t.references :habit, null: false, foreign_key: true
      t.references :day_article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
