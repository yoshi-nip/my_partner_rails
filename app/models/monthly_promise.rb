# == Schema Information
#
# Table name: monthly_promises
#
#  id           :bigint           not null, primary key
#  body         :string
#  if_then_plan :string
#  month        :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_monthly_promises_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MonthlyPromise < ApplicationRecord
  validates :month, presence: true ,uniqueness: true
  validates :body, presence: true
  validates :if_then_plan, presence: true

  belongs_to :user
end
