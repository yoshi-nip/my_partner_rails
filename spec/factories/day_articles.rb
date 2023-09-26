# == Schema Information
#
# Table name: day_articles
#
#  id         :bigint           not null, primary key
#  body       :string
#  day        :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_day_articles_on_day      (day) UNIQUE
#  index_day_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :day_article do
    day { Faker::Date.between(from: "2020-01-01", to: "2022-12-31") }
    body { Faker::Lorem.paragraphs(number: 3).join(" ") }
  end
end
