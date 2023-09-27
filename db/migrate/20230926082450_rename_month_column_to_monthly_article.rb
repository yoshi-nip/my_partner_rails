class RenameMonthColumnToMonthlyArticle < ActiveRecord::Migration[7.0]
  def change
    rename_column :monthly_articles, :month, :beginning_of_month
  end
end
