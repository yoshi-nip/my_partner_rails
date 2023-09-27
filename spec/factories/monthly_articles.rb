# == Schema Information
#
# Table name: monthly_articles
#
#  id                 :bigint           not null, primary key
#  beginning_of_month :date
#  body               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_monthly_articles_on_beginning_of_month  (beginning_of_month) UNIQUE
#  index_monthly_articles_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :monthly_article do
    beginning_of_month { Faker::Date.between(from: "2020-01-01", to: "2022-12-31").beginning_of_month }
    body { Faker::Lorem.paragraphs(number: 3).join(" ") }
  end
end
