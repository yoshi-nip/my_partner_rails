class AddIndexToDayArticlesDay < ActiveRecord::Migration[7.0]
  def change
    add_index :day_articles, :day, unique: true
  end
end
