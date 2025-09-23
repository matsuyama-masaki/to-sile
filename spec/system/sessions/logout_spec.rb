require 'rails_helper'

RSpec.describe "ログアウト機能", type: :system do
  describe "正常系" do
    # テストユーザを定義
    let(:user) { create(:user, email: "test@example.com", password: "password") }

    it "ログイン後にログアウトできること" do
      # ログインする
      visit new_user_session_path
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: "password"
      click_button "ログイン"
      
      # ログイン成功を確認する
      expect(page).to have_content "ログインしました。"
      
      # マイページをクリック
      click_link "マイページ"
      
      # 確認ダイアログでボタンをクリック
      accept_confirm("ログアウトしますか？") do
        click_link "ログアウト"
      end
      
      # ログアウト成功を確認
      expect(page).to have_content "ログアウトしました。"
      # TOP画面に遷移すること
      expect(current_path).to eq root_path
    end
  end

  describe "異常系" do
    # テストユーザを定義
    let(:user) { create(:user, email: "test@example.com", password: "password") }
    
    it "ログアウト確認をキャンセルできること" do
      # ログインする
      visit new_user_session_path
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: "password"
      click_button "ログイン"
      
      # ログイン成功を確認する
      expect(page).to have_content "ログインしました。"

      # マイページをクリック
      click_link "マイページ"
      
      # 確認ダイアログでキャンセルをクリックする
      dismiss_confirm("ログアウトしますか？") do
        click_link "ログアウト"
      end
      # ログアウトが存在すること
      expect(page).to have_link "ログアウト"
      # マイページが存在すること
      expect(page).to have_link "マイページ"
      #「ログアウトしました」が表示されないこと
      expect(page).not_to have_content "ログアウトしました。"
      # ログインが存在しないこと
      expect(page).not_to have_link "ログイン"
    end
  end
end
