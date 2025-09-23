require 'rails_helper'

RSpec.describe "アカウント登録機能", type: :system do
  describe "正常系" do
    it "新規登録できること" do
      # FactoryBotからテストデータを取得
      user_attributes =  FactoryBot.attributes_for(:user)
      
      # アカウント登録画面に遷移
      visit new_user_registration_path
      
      # factry bot の内容を入力する
      fill_in "ユーザ名", with: user_attributes[:name]
      fill_in "メールアドレス", with:  user_attributes[:email]
      fill_in "パスワード", with:  user_attributes[:password]
      fill_in "パスワード(確認用)", with:  user_attributes[:password_confirmation]
      click_button "アカウント登録"
      
      # 以下のメッセージが表示されること
      expect(page).to have_content "アカウント登録が完了しました"
      # 投稿一覧画面に遷移すること
      expect(page).to have_current_path(posts_path)

      # データベースにユーザ名、メールアドレスが保存されていること
      user = User.last
      expect(user.name).to eq user_attributes[:name]
      expect(user.email).to eq user_attributes[:email]
    end
  end

  describe "異常系" do
    it "重複したメールアドレスでは登録できないこと" do
      # 事前にメールアドレスのユーザーを作成する
      before_user = create(:user, email: "duplicate@example.com")
      
      # アカウント登録画面に遷移
      visit new_user_registration_path
      
      # 以下の内容を入力する
      fill_in "ユーザ名", with: "新規ユーザー"
      fill_in "メールアドレス", with: before_user.email
      fill_in "パスワード", with: "password123"
      fill_in "パスワード(確認用)", with: "password123"
      click_button "アカウント登録"
      
      # エラーメッセージが表示されること
      expect(page).to have_content "はすでに存在します"
      
      # 同じページに留まること
      expect(page).to have_current_path(new_user_registration_path)
      
      # データベースに新しいユーザーが作成されていないこと
      expect(User.count).to eq 1
    end

    it "必須項目が未入力の場合は登録できないこと" do
      # アカウント登録画面に遷移
      visit new_user_registration_path
      
      # 何も入力せずに登録ボタンをクリック
      click_button "アカウント登録"
      
      # エラーメッセージが表示されること
      expect(page).to have_content "を入力してください"
      
      # 同じページに留まること
      expect(page).to have_current_path(new_user_registration_path)
      
      # データベースにユーザーが作成されていないこと
      expect(User.count).to eq 0
    end
  end
end
