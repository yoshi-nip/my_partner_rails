class CreateMonthlyArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_articles do |t|
      t.date :month
      t.string :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
