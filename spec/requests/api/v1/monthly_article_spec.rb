require "rails_helper"

RSpec.describe "Api::V1::MonthlyArticles", type: :request do
  describe "GET /index" do
    subject { get(api_v1_monthly_articles_path, headers:) }

    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "/api/v1/monthly_articlesのルートの時" do
      before do
        3.times do |n|
          create(:monthly_article, beginning_of_month: "2022-#{1 + n}-1", user:)
        end
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
        expect(res[0].keys).to eq ["id", "beginning_of_month", "body", "updated_at", "user_id", "user"]
      end

      it "関連づけられたuserのserializerが適用されている" do
        res = JSON.parse(response.body)
        expect(res[0]["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end
  end

  describe "GET/show" do
    subject { get(api_v1_monthly_article_path(monthly_article_id), headers:) }

    let(:monthly_article) { create(:monthly_article, user:) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "/api/v1/monthly_articles/:idのルートの時(正しい値)" do
      let(:monthly_article_id) { monthly_article.id }
      before do
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end

      it "詳細を取得できる" do
        res = JSON.parse(response.body)

        expect(res.length).to eq 6
        expect(res.keys).to eq ["id", "beginning_of_month", "body", "updated_at", "user_id", "user"]
        expect(res["id"]).to eq monthly_article.id
        expect(res["body"]).to eq monthly_article.body
        expect(res["beginning_of_month"]).to eq monthly_article.beginning_of_month.strftime("%Y-%m-%d")
        expect(res["updated_at"]).to be_present
        expect(res["user_id"]).to eq monthly_article.user_id
        expect(res["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end

    context "/api/v1/monthly_articles/:idのルートの時(誤った値)" do
      let(:monthly_article_id) { 99_999_999 }

      it "httpステータスがエラーが返ってくる" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST/create" do
    subject { post(api_v1_monthly_articles_path, params: monthly_articles_params, headers:) }

    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの時、適切なパラメータをもとに記事が作成される" do
      let(:monthly_articles_params) { { monthly_article: attributes_for(:monthly_article) } }
      it "現在のユーザをもとに記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(MonthlyArticle.last.user_id).to eq(user.id)
        expect(response).to have_http_status(:created)
        expect(res["beginning_of_month"]).to eq monthly_articles_params[:monthly_article][:beginning_of_month].strftime("%Y-%m-%d")
        expect(res["body"]).to eq monthly_articles_params[:monthly_article][:body]
      end
    end

    context "正しくないパラメータでリクエストを送った時" do
      let(:monthly_articles_params) { attributes_for(:monthly_article) }
      it "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "PUT /update" do
    subject { put(api_v1_monthly_article_path(monthly_article), params: monthly_articles_params, headers:) }

    let!(:monthly_article) { create(:monthly_article, user:) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの時、適切なパラメータをもとに記事が更新される" do
      let(:monthly_articles_params) { { monthly_article: { body: "新しいテキスト" } } }

      it "現在のユーザをもとに記事が更新できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(monthly_article.body).not_to eq "新しいテキスト"
        expect(res["body"]).to eq "新しいテキスト"
      end
    end

    context "不適切なパラメータでリクエストを送った時" do
      let(:monthly_articles_params) { { title: "新しいタイトル" } } # paramsの形式がおかしい
      it "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete(api_v1_monthly_article_path(monthly_article), headers:) }

    let!(:monthly_article) { create(:monthly_article, user:) }
    let(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの場合、記事が削除される" do
      it "現在のユーザをもとに記事が削除される" do
        # リクエストを送信
        subject
        # HTTPステータスが正常なことを検証　204-deleteやput時に返ってくることのあるステータスz
        expect(response).to have_http_status(:no_content)
        # データベース上で記事が削除されたことを検証
        expect(DayArticle.find_by(id: monthly_article.id)).to be_nil
      end
    end
  end
end
