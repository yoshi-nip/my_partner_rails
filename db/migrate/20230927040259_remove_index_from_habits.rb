class RemoveIndexFromHabits < ActiveRecord::Migration[7.0]
  def change
    remove_index :habits, :start_date, unique: true
  end
end
