# == Schema Information
#
# Table name: weekly_articles
#
#  id         :bigint           not null, primary key
#  body       :string
#  week       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_weekly_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class WeeklyArticle < ApplicationRecord
  belongs_to :user
end
