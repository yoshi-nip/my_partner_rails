# == Schema Information
#
# Table name: monthly_articles
#
#  id                 :bigint           not null, primary key
#  beginning_of_month :date
#  body               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_monthly_articles_on_beginning_of_month  (beginning_of_month) UNIQUE
#  index_monthly_articles_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe MonthlyArticle, type: :model do
  context "正しく情報が指定されているとき" do
    let!(:user) { create(:user) }
    let!(:monthly_article) { build(:monthly_article, user_id: user.id) }
    it "記事が作成される" do
      expect(monthly_article).to be_valid
    end

    it "記事とユーザーとの関連付けが定義されている" do
      association = MonthlyArticle.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  # 異常系
  context "正しく情報が指定されていない時(taken)" do
    let!(:user) { create(:user) }
    let!(:monthly_article) { create(:monthly_article, user_id: user.id) }
    let(:monthly_article_month_duplication) { build(:monthly_article, beginning_of_month: monthly_article.beginning_of_month, user_id: user.id) }

    it "月が重複している時、記事が保存できない。" do
      monthly_article_month_duplication.valid?
      expect(monthly_article_month_duplication.errors.errors[0].type).to eq :taken
    end
  end

  context "正しく情報が指定されていない時(blank)" do
    let!(:user) { create(:user) }
    let(:monthly_article_user_blank) { build(:monthly_article, user_id: nil) }
    let(:monthly_article_body_blank) { build(:monthly_article, body: "", user_id: user.id) }
    let(:monthly_article_month_blank) { build(:monthly_article, beginning_of_month: "", user_id: user.id) }

    it "ユーザーがない時記事が作成されない" do
      monthly_article_user_blank.valid?
      expect(monthly_article_user_blank.errors.errors[0].type).to eq :blank
    end

    it "日付がない時記事が作成されない" do
      monthly_article_month_blank.valid?
      expect(monthly_article_month_blank.errors.errors[0].type).to eq :blank
    end

    it "本文がない時記事が作成されない" do
      monthly_article_body_blank.valid?
      expect(monthly_article_body_blank.errors.errors[0].type).to eq :blank
    end
  end
end
