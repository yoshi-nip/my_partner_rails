require "rails_helper"

RSpec.describe "Api::V1::Habits", type: :request do
  describe "GET /index" do
    subject { get(api_v1_habits_path, headers:) }

    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "/api/v1/habitsのルートの時" do
      before do
        create_list(:habit, 3, user:)
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
        expect(res[0].keys).to eq ["id", "name", "start_date", "updated_at", "user_id", "user"]
      end

      it "関連づけられたuserのserializerが適用されている" do
        res = JSON.parse(response.body)
        expect(res[0]["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end
  end

  describe "GET/show" do
    subject { get(api_v1_habit_path(habit_id), headers:) }

    let(:habit) { create(:habit, user:) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "/api/v1/habits/:idのルートの時(正しい値)" do
      let(:habit_id) { habit.id }
      before do
        subject
      end

      it "httpステータスが正常である" do
        expect(response).to have_http_status(:ok)
      end

      it "詳細を取得できる" do
        res = JSON.parse(response.body)

        expect(res.length).to eq 6
        expect(res.keys).to eq ["id", "name", "start_date", "updated_at", "user_id", "user"]
        expect(res["id"]).to eq habit.id
        expect(res["name"]).to eq habit.name
        expect(res["start_date"]).to eq habit.start_date.strftime("%Y-%m-%d")
        expect(res["updated_at"]).to be_present
        expect(res["user_id"]).to eq habit.user_id
        expect(res["user"].keys).to eq ["id", "name", "email", "updated_at"]
      end
    end

    context "/api/v1/habits/:idのルートの時(誤った値)" do
      let(:habit_id) { 99_999_999 }

      it "httpステータスがエラーが返ってくる" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST/create" do
    subject { post(api_v1_habits_path, params: habits_params, headers:) }

    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの時、適切なパラメータをもとに記事が作成される" do
      let(:habits_params) { { habit: attributes_for(:habit) } }
      it "現在のユーザをもとに記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(Habit.last.user_id).to eq(user.id)
        expect(response).to have_http_status(:created)
        expect(res["start_date"]).to eq habits_params[:habit][:start_date].strftime("%Y-%m-%d")
        expect(res["name"]).to eq habits_params[:habit][:name]
      end
    end

    context "正しくないパラメータでリクエストを送った時" do
      let(:habits_params) { attributes_for(:habit) }
      it "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "PUT /update" do
    subject { put(api_v1_habit_path(habit), params: habits_params, headers:) }

    let!(:habit) { create(:habit, user:) }
    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの時、適切なパラメータをもとに記事が更新される" do
      let(:habits_params) { { habit: { body: "新しいテキスト" } } }

      it "現在のユーザをもとに記事が更新できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(habit.name).not_to eq "新しいテキスト"
        expect(res["body"]).to eq "新しいテキスト"
      end
    end

    context "不適切なパラメータでリクエストを送った時" do
      let(:habits_params) { { title: "新しいタイトル" } } # paramsの形式がおかしい
      it "エラーになる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete(api_v1_habit_path(habit), headers:) }

    let!(:habit) { create(:habit, user:) }
    let(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }

    context "ログインユーザーの場合、記事が削除される" do
      it "現在のユーザをもとに記事が削除される" do
        # リクエストを送信
        subject
        # HTTPステータスが正常なことを検証　204-deleteやput時に返ってくることのあるステータスz
        expect(response).to have_http_status(:no_content)
        # データベース上で記事が削除されたことを検証
        expect(Habit.find_by(id: habit.id)).to be_nil
      end
    end
  end
end
