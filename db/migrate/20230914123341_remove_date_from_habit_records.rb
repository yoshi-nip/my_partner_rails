class RemoveDateFromHabitRecords < ActiveRecord::Migration[7.0]
  def change
    remove_column :habit_records, :date, :date
  end
end
