require "rails_helper"

RSpec.describe "Api::V1::DayArticles", type: :request do
  describe "GET /index" do
    subject { get(api_v1_day_articles_path) }

    context "/api/v1/day_articlesのルートの時" do
      before do
        create_list(:day_article, 3)
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end

      it "一覧を取得できる" do
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
      end

      it "想定したkeyが帰ってきている" do
        res = JSON.parse(response.body)
        expect(res[0].keys).to eq ["id", "body", "day", "updated_at", "user_id", "user"]
      end

      it "関連づけられたuserのserializerが適用されている" do
        res = JSON.parse(response.body)
        expect(res[0]["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end
  end

  describe "GET/show" do
    subject { get(api_v1_day_article_path(day_article_id)) }

    let(:day_article) { create(:day_article) }

    context "/api/v1/day_articles/:idのルートの時(正しい値)" do
      let(:day_article_id) { day_article.id }
      before do
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end

      it "詳細を取得できる" do
        res = JSON.parse(response.body)

        expect(res.length).to eq 6
        expect(res.keys).to eq ["id", "body", "day", "updated_at", "user_id", "user"]
        expect(res["id"]).to eq day_article.id
        expect(res["body"]).to eq day_article.body
        expect(res["day"]).to eq day_article.day.strftime("%Y-%m-%d")
        expect(res["updated_at"]).to be_present
        expect(res["user_id"]).to eq day_article.user_id
        expect(res["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end

    context "/api/v1/day_articles/:idのルートの時(誤った値)" do
      let(:day_article_id) { 99_999_999 }

      it "httpステータスがエラーが返ってくる" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST/create" do
    subject { post(api_v1_day_articles_path, params: day_articles_params) }

    let!(:current_user) { create(:user) }

    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "ログインユーザーの時、適切なパラメータをもとに記事が作成される" do
      let(:day_articles_params) { { day_article: attributes_for(:day_article) } }
      it "現在のユーザをもとに記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(DayArticle.last.user_id).to eq(current_user.id)
        expect(response).to have_http_status(:created)
        expect(res["day"]).to eq day_articles_params[:day_article][:day].strftime("%Y-%m-%d")
        expect(res["body"]).to eq day_articles_params[:day_article][:body]
      end
    end

    context "正しくないパラメータでリクエストを送った時" do
      let(:day_articles_params) { attributes_for(:day_article) }
      it "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end
end
