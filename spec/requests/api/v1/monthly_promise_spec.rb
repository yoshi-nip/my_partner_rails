require "rails_helper"

RSpec.describe "Api::V1::MonthlyPromises", type: :request do
  describe "GET /index" do
    subject { get(api_v1_monthly_promises_path) }

    context "/api/v1/monthly_promisesのルートの時" do
      before do
        3.times do |n|
          create(:monthly_article, beginning_of_month: "2022-#{1 + n}-1")
        end
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
