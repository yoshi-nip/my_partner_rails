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
  let!(:habit) { create(:habit) }
  let!(:day_article) { create(:day_article, user_id: habit.user.id) }
  let(:habit_record) { create(:habit_record, habit_id: habit.id, day_article_id: day_article.id) }
  let!(:habit_record_day_article_blank) { build(:habit_record, habit_id: habit.id, day_article_id: "") }
  let!(:habit_record_habit_blank) { build(:habit_record, habit_id: "", day_article_id: day_article.id) }

  context "正常な関連づけがされている" do
    it "日記との関連付けが定義されていることを確認" do
      association = HabitRecord.reflect_on_association(:day_article)
      expect(association.macro).to eq(:belongs_to)
    end

    it "習慣との関連付けが定義されていることを確認" do
      association = HabitRecord.reflect_on_association(:habit)
      expect(association.macro).to eq(:belongs_to)
    end

    it "habit_recordからday_articleの値が取得できる" do
      expect(habit_record.day_article).to eq(day_article)
    end

    it "habit_recordからhabitの値が取得できる" do
      expect(habit_record.habit).to eq(habit)
    end
  end

  context "正常な関連付けがない場合" do
    it "day_article_idがない時レコードが作成されない" do
      habit_record_day_article_blank.valid?
      expect(habit_record_day_article_blank.errors.errors[0].type).to eq :blank
    end

    it "habit_idがない時レコードが作成されない" do
      habit_record_habit_blank.valid?
      expect(habit_record_habit_blank.errors.errors[0].type).to eq :blank
    end
  end
end
