# FactoryBot.define do
#   factory :day_article do
#     day {  }
#     body {  }
#   end
# end
FactoryBot.define do
  factory :day_article do
    day { Faker::Date.between(from: "2020-01-01", to: "2022-12-31") }
    body { Faker::Lorem.paragraphs(number: 3).join(" ") }
  end
end
