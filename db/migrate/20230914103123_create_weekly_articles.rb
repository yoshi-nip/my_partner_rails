class CreateWeeklyArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_articles do |t|
      t.date :week
      t.string :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
