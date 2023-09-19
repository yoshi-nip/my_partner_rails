class AddIndexToHabitsStartDate < ActiveRecord::Migration[7.0]
  def change
    add_index :habits, :start_date, unique: true
  end
end
