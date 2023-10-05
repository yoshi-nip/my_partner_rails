require "rails_helper"

RSpec.describe "Api::V1::DayArticles", type: :request do
  describe "GET /index" do
    subject { get(api_v1_day_articles_path,headers:) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "/api/v1/day_articlesのルートの時" do
      before do
        create_list(:day_article, 3)
        subject
      end

      fit "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end

      fit "一覧を取得できる" do
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
      end

      it "想定したkeyが帰ってきている" do
        res = JSON.parse(response.body)
        expect(res[0].keys).to eq ["id", "body", "day", "updated_at", "user_id", "user"]
      end

      fit "関連づけられたuserのserializerが適用されている" do
        res = JSON.parse(response.body)
        expect(res[0]["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end
  end

  describe "GET/show" do
    subject { get(api_v1_day_article_path(day_article_id),headers:) }

    let(:day_article) { create(:day_article,user:) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "/api/v1/day_articles/:idのルートの時(正しい値)" do
      let(:day_article_id) { day_article.id }
      before do
        subject
      end

      fit "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end

      fit "詳細を取得できる" do
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

      fit "httpステータスがエラーが返ってくる" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST/create" do
    subject { post(api_v1_day_articles_path, params: day_articles_params,headers:) }

    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの時、適切なパラメータをもとに記事が作成される" do
      let(:day_articles_params) { { day_article: attributes_for(:day_article) } }
      fit "現在のユーザをもとに記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(DayArticle.last.user_id).to eq(user.id)
        expect(response).to have_http_status(:created)
        expect(res["day"]).to eq day_articles_params[:day_article][:day].strftime("%Y-%m-%d")
        expect(res["body"]).to eq day_articles_params[:day_article][:body]
      end
    end

    context "正しくないパラメータでリクエストを送った時" do
      let(:day_articles_params) { attributes_for(:day_article) }
      fit "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "PUT /update" do
    subject { put(api_v1_day_article_path(day_article), params: day_articles_params,headers:) }

    let!(:day_article) { create(:day_article, user: ) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの時、適切なパラメータをもとに記事が更新される" do
      let(:day_articles_params) { { day_article: { body: "新しいテキスト" } } }

      fit "現在のユーザをもとに記事が更新できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(day_article.body).not_to eq "新しいテキスト"
        expect(res["body"]).to eq "新しいテキスト"
      end
    end

    context "不適切なパラメータでリクエストを送った時" do
      let(:day_articles_params) { { title: "新しいタイトル" } } # paramsの形式がおかしい
      fit "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete(api_v1_day_article_path(day_article),headers:) }

    let!(:day_article) { create(:day_article, user: ) }
    let(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの場合、記事が削除される" do
      fit "現在のユーザをもとに記事が削除される" do
        # リクエストを送信
        subject
        # HTTPステータスが正常なことを検証　204-deleteやput時に返ってくることのあるステータスz
        expect(response).to have_http_status(:no_content)
        # データベース上で記事が削除されたことを検証
        expect(DayArticle.find_by(id: day_article.id)).to be_nil
      end
    end
  end
end
