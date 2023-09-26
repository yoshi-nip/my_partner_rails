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
#  index_habits_on_start_date  (start_date) UNIQUE
#  index_habits_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Habit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
