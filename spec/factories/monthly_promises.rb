# == Schema Information
#
# Table name: monthly_promises
#
#  id                 :bigint           not null, primary key
#  beginning_of_month :date
#  body               :string
#  if_then_plan       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_monthly_promises_on_beginning_of_month  (beginning_of_month) UNIQUE
#  index_monthly_promises_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :monthly_promise do
    beginning_of_month { Faker::Date.between(from: "2020-01-01", to: "2022-12-31").beginning_of_month }
    body { Faker::Lorem.paragraphs(number: 2).join(" ") }
    if_then_plan { Faker::Lorem.paragraphs(number: 2).join(" ") }
  end
end
