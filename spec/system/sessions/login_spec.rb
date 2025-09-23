require 'rails_helper'

RSpec.describe "ログイン機能", type: :system do
  describe "正常系" do
    # テストユーザを定義
    let(:user) { create(:user, email: "test@example.com", password: "password") }

    it "正しい情報でログインできること" do
      # ログイン画面に遷移
      visit new_user_session_path

      # メールアドレスを入力（テストユーザ）
      fill_in "user[email]",	with: user.email
      # パスワード入力
      fill_in "user[password]", with: "password"
      # ログイン押下
      click_button "ログイン"
      
      #「ログインしました」が表示されること
      expect(page).to have_content "ログインしました"
      # 投稿一覧画面に遷移すること
      expect(current_path).to eq posts_path
    end
  end
  
  describe "異常系" do
    # テストユーザを定義
    let(:user) { create(:user, email: "test@example.com", password: "password") }
    
    it "間違ったパスワードでログインに失敗する" do
      # ログイン画面に遷移
      visit new_user_session_path
      
      # メールアドレスを入力（テストユーザ）
      fill_in "user[email]", with: user.email
      # パスワード入力
      fill_in "user[password]", with: "password123"
      # ログイン押下
      click_button "ログイン"
      
      #「メールアドレスまたはパスワードが違います」が表示されること
      expect(page).to have_content "メールアドレスまたはパスワードが違います"
      # ログイン画面のままであること
      expect(current_path).to eq new_user_session_path
    end

    it "存在しないメールアドレスでログインに失敗する" do
      # ログイン画面に遷移
      visit new_user_session_path

      # メールアドレスを入力
      fill_in "user[email]", with: "nonexistent@example.com"
      # パスワード入力
      fill_in "user[password]", with: "password"
      # ログイン押下
      click_button "ログイン"
      
      #「メールアドレスまたはパスワードが違います」が表示されること
      expect(page).to have_content "メールアドレスまたはパスワードが違います"
      # ログイン画面のままであること
      expect(current_path).to eq new_user_session_path
    end

    it "空のフィールドでログインに失敗する" do
      # ログイン画面に遷移
      visit new_user_session_path
      
      # 何も入力せずにログインボタンを押下
      click_button "ログイン"
      
      #「メールアドレスまたはパスワードが違います」が表示されること
      expect(page).to have_content "メールアドレスまたはパスワードが違います"
      # ログイン画面のままであること
      expect(current_path).to eq new_user_session_path
    end
  end
end


