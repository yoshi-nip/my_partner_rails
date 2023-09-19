class AddIndexToMonthlyPromisesMonth < ActiveRecord::Migration[7.0]
  def change
    add_index :monthly_promises, :month, unique: true
  end
end
