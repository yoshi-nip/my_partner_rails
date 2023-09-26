# == Schema Information
#
# Table name: habit_records
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  day_article_id :bigint           not null
#  habit_id       :bigint           not null
#
# Indexes
#
#  index_habit_records_on_day_article_id  (day_article_id)
#  index_habit_records_on_habit_id        (habit_id)
#
# Foreign Keys
#
#  fk_rails_...  (day_article_id => day_articles.id)
#  fk_rails_...  (habit_id => habits.id)
#
require "rails_helper"

RSpec.describe HabitRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
