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
end
