require "rails_helper"

RSpec.describe "Api::V1::Habits", type: :request do
  describe "GET /index" do
    subject { get(api_v1_habits_path) }

    context "/api/v1/habitsのルートの時" do
      before do
        create_list(:habit, 3)
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
