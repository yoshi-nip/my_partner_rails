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
#  index_day_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class DayArticle < ApplicationRecord
  belongs_to :user
  has_many :habit_records
end
