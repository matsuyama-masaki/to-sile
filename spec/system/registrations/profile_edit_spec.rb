require 'rails_helper'

RSpec.describe User, type: :model do
  describe "プロフィール更新のバリデーション" do
    # テストユーザを作成
    let(:user) { create(:user) }
    
    it "ユーザ名、メールアドレスを更新できる" do
      
      user.update(name: "新しい名前", email: "new@example.com")
      # 有効であること
      expect(user).to be_valid
    end
    
    it "無効なメールアドレスでは更新できない" do
      #  無効な形式のメルアドを設定
      user.email = "invalid_email"
      # 無効であること
      expect(user).not_to be_valid
      # 以下のメッセージが表示されること
      expect(user.errors[:email]).to include("は正しい形式で入力してください")
    end

    it "空白のユーザ名は更新できない" do
      #  無効な形式のメルアドを設定
      user.name = ""
      # 無効であること
      expect(user).not_to be_valid
      # 以下のメッセージが表示されること
      expect(user.errors[:name]).to include("を入力してください")
    end
  end
end
