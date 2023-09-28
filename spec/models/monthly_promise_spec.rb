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
require "rails_helper"

RSpec.describe MonthlyPromise, type: :model do
  context "正しく情報が指定されているとき" do
    let!(:user) { create(:user) }
    let!(:monthly_promise) { build(:monthly_promise, user_id: user.id) }
    it "記事が作成される" do
      expect(monthly_promise).to be_valid
    end

    it "月の約束事とユーザーとの関連付けが定義されている" do
      association = MonthlyPromise.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  # 異常系
  context "正しく情報が指定されていない時(taken)" do
    let!(:user) { create(:user) }
    let!(:monthly_promise) { create(:monthly_promise, user_id: user.id) }
    let(:monthly_promise_month_duplication) { build(:monthly_promise, beginning_of_month: monthly_promise.beginning_of_month, user_id: user.id) }

    it "月が重複している時、記事が保存できない。" do
      monthly_promise_month_duplication.valid?
      expect(monthly_promise_month_duplication.errors.errors[0].type).to eq :taken
    end
  end

  context "正しく情報が指定されていない時(blank)" do
    let!(:user) { create(:user) }
    let(:monthly_promise_user_blank) { build(:monthly_promise, user_id: nil) }
    let(:monthly_promise_body_blank) { build(:monthly_promise, body: "", user_id: user.id) }
    let(:monthly_promise_if_then_plan_blank) { build(:monthly_promise, if_then_plan: "", user_id: user.id) }
    let(:monthly_promise_month_blank) { build(:monthly_promise, beginning_of_month: "", user_id: user.id) }

    it "ユーザーがない時記事が作成されない" do
      monthly_promise_user_blank.valid?
      expect(monthly_promise_user_blank.errors.errors[0].type).to eq :blank
    end

    it "日付がない時記事が作成されない" do
      monthly_promise_month_blank.valid?
      expect(monthly_promise_month_blank.errors.errors[0].type).to eq :blank
    end

    it "本文がない時記事が作成されない" do
      monthly_promise_body_blank.valid?
      expect(monthly_promise_body_blank.errors.errors[0].type).to eq :blank
    end

    it "対策がない時記事が作成されない" do
      monthly_promise_if_then_plan_blank.valid?
      expect(monthly_promise_if_then_plan_blank.errors.errors[0].type).to eq :blank
    end
  end
end
