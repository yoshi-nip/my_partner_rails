class AddIndexToMonthlyArticlesMonth < ActiveRecord::Migration[7.0]
  def change
    add_index :monthly_articles, :month, unique: true
  end
end
