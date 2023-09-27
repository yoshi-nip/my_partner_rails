require 'rails_helper'

RSpec.describe "Api::V1::DayArticles", type: :request do
  describe "GET /index" do
    subject{ get(api_v1_day_articles_path) }
    context "/api/v1/day_articlesのルートの時" do
      let!(:day_article){create(:day_article)}
      let!(:day_article2){create(:day_article)}
      let!(:day_article3){create(:day_article)}

      fit "httpステータスが正常である" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 3
      end

      fit "一覧を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
      end

      fit "想定したkeyが帰ってきている" do
        subject
        res = JSON.parse(response.body)
        expect(res[0].keys).to eq ["id", "body","day" ,"updated_at", "user_id","user"]
      end


      fit "関連づけられたuserのserializerが適用されている" do
        subject
        res = JSON.parse(response.body)
        expect(res[0]["user"].keys).to eq ["id", "name", "email","updated_at"]
      end
    end
  end
end
