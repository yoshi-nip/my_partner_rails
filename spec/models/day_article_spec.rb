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
#  index_day_articles_on_day      (day) UNIQUE
#  index_day_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe DayArticle, type: :model do
  context "正しく情報が指定されているとき" do
    let!(:user) { create(:user) }
    let!(:day_article) { build(:day_article, user_id: user.id) }
    it "記事が作成される" do
      expect(day_article).to be_valid
    end

    it "ユーザーとの関連付けが定義されている" do
      association = DayArticle.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  # 異常系
  context "正しく情報が指定されていない時(taken)" do
    let!(:user) { create(:user) }
    let!(:day_article) { create(:day_article, user_id: user.id) }
    let(:day_article_month_duplication) { build(:day_article, day: day_article.day, user_id: user.id) }

    it "日付が重複している時、記事が保存できない。" do
      day_article_month_duplication.valid?
      expect(day_article_month_duplication.errors.errors[0].type).to eq :taken
    end
  end

  context "正しく情報が指定されていない時()" do
    let(:day_article_user_blank) { build(:day_article, user_id: "") }
    let(:day_article_body_blank) { build(:day_article, body: "") }
    let(:day_article_day_blank) { build(:day_article, day: "") }
    it "ユーザーがない時記事が作成されない" do
      day_article_user_blank.valid?
      expect(day_article_user_blank.errors.errors[0].type).to eq :blank
    end

    it "日付がない時記事が作成されない" do
      day_article_day_blank.valid?
      expect(day_article_day_blank.errors.errors[0].type).to eq :blank
    end

    it "本文がない時記事が作成されない" do
      day_article_body_blank.valid?
      expect(day_article_body_blank.errors.errors[0].type).to eq :blank
    end
  end
end
