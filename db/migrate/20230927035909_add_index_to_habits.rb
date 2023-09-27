class AddIndexToHabits < ActiveRecord::Migration[7.0]
  def change
    add_index :habits, :name, unique: true
  end
end
