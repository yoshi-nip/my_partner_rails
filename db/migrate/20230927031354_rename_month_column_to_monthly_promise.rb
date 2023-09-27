class RenameMonthColumnToMonthlyPromise < ActiveRecord::Migration[7.0]
  def change
    rename_column :monthly_promises, :month, :beginning_of_month
  end
end
