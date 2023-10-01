RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/users/sing_in" do
    subject { post(api_v1_user_session_path, params: user_params) }

    context "適切なパラメータが送信されたとき" do
      let(:user) { create(:user) }
      let(:user_params) { { email: user.email, password: user.password } }
      it "ログインができる" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "想定したヘッダー情報が返ってくる" do
        subject
        expected_headers = ["token-type", "access-token", "client", "uid", "expiry", "authorization"]
        expected_headers.each do |header_key|
          expect(response.header[header_key]).to be_present
        end
      end
    end

    context "DBにないユーザー情報を送信した時" do
      let(:user) { create(:user) }
      let(:user_params) { attributes_for(:user) }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
      end
    end

    context "passwordがない時" do
      let(:user) { create(:user) }
      let(:user_params) { { email: user.email, password: nil } }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
      end
    end

    context "emailがない時" do
      let(:user) { create(:user) }
      let(:user_params) { { email: nil, password: user.password } }
      it "エラーが返ってくる" do
        expect { subject }.to raise_error NoMethodError
      end
    end

    context "passwordが違う時" do
      let(:user) { create(:user) }
      let(:user_params) { { email: user.email, password: "mineraruwater" } }
      # let(:user_params) { attributes_for(:user,name: nil) }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
      end
    end

    context "emailが違う時" do
      let(:user) { create(:user) }
      let(:user_params) { { email: "mineraruwater@mineraru.com", password: user.password } }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
      end
    end
  end

  describe "DELETE /api/v1/users/sing_in" do
    subject { delete(destroy_api_v1_user_session_path, headers:) }

    context "適切なパラメータが送信されたとき" do
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }
      it "ログアウトができる" do
        expect(headers).to be_present
        expect { subject }.to change { user.reload.tokens.present? }.from(true).to(false)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["success"]).to eq true
      end
    end

    context "token情報が違う時" do
      let(:user) { create(:user) }
      let!(:headers) {
        { "access-token" => "1111",
          "token-type" => "kbndk",
          "client" => "rrrr",
          "expiry" => "35353",
          "uid" => "222",
          "authorization" => "" }
      }
      it "ログアウトが失敗する" do
        expect(headers).to be_present
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"][0]).to eq "User was not found or was not logged in."
        expect(response).to have_http_status(:not_found) # ログアウト後のレスポンスステータスを確認
      end
    end
  end
end
