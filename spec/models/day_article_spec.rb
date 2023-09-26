require "rails_helper"

RSpec.describe DayArticle, type: :model do
  context "正しく情報が指定されているとき" do
    let!(:user) { create(:user) }
    let!(:day_article) { build(:day_article,user_id: user.id) }
    fit "ユーザーが作成される" do
      expect(day_article).to be_valid
    end

    fit 'ユーザーとの関連付けが定義されている' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  #異常系
  context "正しく情報が指定されていない時" do
    let!(:user) { create(:user) }
    let(:day_article_user_blank) { build(:day_article) }
    let(:day_article_body_blank) { build(:day_article,body: "") }
    let(:day_article_day_blank) { build(:day_article,day:"") }
    fit "ユーザーがない時記事が作成されない" do
      expect(day_article_user_blank).not_to be_valid
    end

    fit "日付がない時記事が作成されない" do
      expect(day_article_user_blank).not_to be_valid
    end

    fit "本文がない時記事が作成されない" do
      expect(day_article_user_blank).not_to be_valid
    end

  end
end
