class AddIndexToWeeklyArticlesWeek < ActiveRecord::Migration[7.0]
  def change
    add_index :weekly_articles, :week, unique: true
  end
end
