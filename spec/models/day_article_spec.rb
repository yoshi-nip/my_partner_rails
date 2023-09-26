require "rails_helper"

RSpec.describe DayArticle, type: :model do
  context "正しく情報が指定されているとき" do
    let!(:user) { create(:user) }
    let!(:day_article) { build(:day_article, user_id: user.id) }
    it "ユーザーが作成される" do
      expect(day_article).to be_valid
    end

    it "ユーザーとの関連付けが定義されている" do
      association = DayArticle.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  # 異常系
  context "正しく情報が指定されていない時" do
    let!(:user) { create(:user) }
    let(:day_article_user_blank) { build(:day_article) }
    let(:day_article_body_blank) { build(:day_article, body: "", user_id: user.id) }
    let(:day_article_day_blank) { build(:day_article, day: "", user_id: user.id) }
    it "ユーザーがない時記事が作成されない" do
      expect(day_article_user_blank).not_to be_valid
    end

    it "日付がない時記事が作成されない" do
      expect(day_article_day_blank).not_to be_valid
    end

    it "本文がない時記事が作成されない" do
      expect(day_article_body_blank).not_to be_valid
    end
  end
end
