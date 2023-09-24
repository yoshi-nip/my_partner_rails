require "rails_helper"

RSpec.describe User, type: :model do
  context "正しく情報が指定されているとき" do
    let(:user) { build(:user) }
    it "ユーザーが作成される" do
      # テストの内容をここに書く
      expect(user).to be_valid
    end
  end

  # #異常系テスト
  context "nameが正しく入力されていない時" do
    let(:user_name_maximum) { build(:user, name: "ホゲホゲホゲホゲホゲホゲホゲホゲ") }
    let(:user_name_blank) { build(:user, name: "") }
    it "nameの文字が15文字以上の時、userが作成されない" do
      # テストの内容をここに書く
      expect(user_name_maximum).not_to be_valid
    end

    it "nameが空白の時userが作成されない" do
      # テストの内容をここに書く
      expect(user_name_blank).not_to be_valid
    end
  end

  context "emailが正しく入力されていない時" do
    let(:user_adress_at_two) { build(:user, email: "hogehoge@hoge@hoge.com") }
    let(:user_adress_at_last) { build(:user, email: "hogehoge@hoge.com@") }
    let(:user_adress_blank) { build(:user, email: "") }
    it "emailに@が2つ入っている時、userが作成されない" do
      # テストの内容をここに書く
      expect(user_adress_at_two).not_to be_valid
    end

    it "emailの最後が@の時、userが作成されない" do
      # テストの内容をここに書く
      expect(user_adress_at_last).not_to be_valid
    end

    it "emailが空白の時、userが作成されない" do
      # テストの内容をここに書く
      expect(user_adress_blank).not_to be_valid
    end
  end

  context "passwordが正しく入力されていない時" do
    let(:user_password_minimum) { build(:user, password: "grtnh") }
    let(:user_password_blank) { build(:user, password: "") }
    it "passwordが6文字以下の時userが作成されない" do
      # テストの内容をここに書く
      expect(user_password_minimum).not_to be_valid
    end

    it "passwordが空白の時ユーザーが作成されない" do
      # テストの内容をここに書く
      expect(user_password_blank).not_to be_valid
    end
  end
end
