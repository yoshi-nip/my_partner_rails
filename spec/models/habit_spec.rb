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
require "rails_helper"

RSpec.describe Habit, type: :model do
  context "正しく情報が指定されているとき" do
    let!(:user) { create(:user) }
    let!(:habit) { build(:habit, user_id: user.id) }
    it "習慣が作成される" do
      expect(habit).to be_valid
    end

    it "ユーザーとの関連付けが定義されている" do
      association = Habit.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  # 異常系
  context "正しく情報が指定されていない時(taken)" do
    let!(:user) { create(:user) }
    let!(:habit) { create(:habit, user_id: user.id) }
    let(:habit_name_duplication) { build(:habit, name: habit.name, user_id: user.id) }

    it "名前が重複している時、記事が保存できない。" do
      habit_name_duplication.valid?
      expect(habit_name_duplication.errors.errors[0].type).to eq :taken
    end
  end

  context "正しく情報が指定されていない時()" do
    let!(:user) { create(:user) }
    let(:habit_user_blank) { build(:habit) }
    let(:habit_name_blank) { build(:habit, name: "", user_id: user.id) }
    let(:habit_start_date_blank) { build(:habit, start_date: "", user_id: user.id) }
    it "ユーザーがない時記事が作成されない" do
      habit_user_blank.valid?
      expect(habit_user_blank.errors.errors[0].type).to eq :blank
    end

    it "開始日がない時記事が作成されない" do
      habit_start_date_blank.valid?
      expect(habit_start_date_blank.errors.errors[0].type).to eq :blank
    end

    it "本文がない時記事が作成されない" do
      habit_name_blank.valid?
      expect(habit_name_blank.errors.errors[0].type).to eq :blank
    end
  end
end
