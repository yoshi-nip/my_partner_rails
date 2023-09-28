require "rails_helper"

RSpec.describe "Api::V1::MonthlyArticles", type: :request do
  describe "GET /index" do
    subject { get(api_v1_monthly_articles_path) }

    context "/api/v1/monthly_articlesのルートの時" do
      before do
        create_list(:monthly_article, 3)
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
