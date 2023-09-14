class CreateDayArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :day_articles do |t|
      t.date :day
      t.string :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
