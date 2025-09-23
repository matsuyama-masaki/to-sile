require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    context "正常系" do
      it "name、email、passwordが有効であること" do
        # ユーザを作成
        user = build(:user)
        # ユーザオブジェクトが有効であること
        expect(user).to be_valid
      end
    end

    context "異常系" do
      it "nameが空の場合、無効であること" do
        # nameが空のユーザを作成
        user = build(:user, name: "")
        # 無効であること
        expect(user).not_to be_valid
        # 以下のメッセージが表示されること
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "emailが空の場合、無効であること" do
        # emailが空のユーザを作成
        user = build(:user, email: "")
        # 無効であること
        expect(user).not_to be_valid
        # 以下のメッセージが表示されること
        expect(user.errors[:email]).to include("を入力してください")
      end

      it "emailが重複している場合、無効であること" do
        # ユーザを作成とDB登録
        create(:user, email: "test@example.com")
        # 同じemailのユーザを作成
        user = build(:user, email: "test@example.com")
        # 無効であること
        expect(user).not_to be_valid
        # 以下のメッセージが表示されること
        expect(user.errors[:email]).to include("はすでに存在します")
      end

      it "emailの形式が正しくない場合、無効であること" do
        # 無効な形式のユーザを作成
        user = build(:user, email: "invalid_email")
        # 無効であること
        expect(user).not_to be_valid
        # 以下のメッセージが表示されること
        expect(user.errors[:email]).to include("は正しい形式で入力してください")
      end

      it "passwordが6文字未満の場合、無効であること" do
        # パスワード６文字未満のユーザを作成
        user = build(:user, password: "12345")
        # 無効であること
        expect(user).not_to be_valid
        # 以下のメッセージが表示されること
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
    end
  end
end
