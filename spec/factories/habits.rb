# == Schema Information
#
# Table name: habits
#
#  id         :bigint           not null, primary key
#  name       :string
#  start_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_habits_on_name     (name) UNIQUE
#  index_habits_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :habit do
    name { Faker::Hobby.activity }
    start_date { Faker::Date.between(from: "2020-01-01", to: "2022-12-31") }
  end
end
