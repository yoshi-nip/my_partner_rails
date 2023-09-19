# == Schema Information
#
# Table name: monthly_articles
#
#  id         :bigint           not null, primary key
#  body       :string
#  month      :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_monthly_articles_on_month    (month) UNIQUE
#  index_monthly_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MonthlyArticle < ApplicationRecord
  validates :month, presence: true, uniqueness: true
  validates :body, presence: true
  belongs_to :user
end
