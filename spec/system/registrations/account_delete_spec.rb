require 'rails_helper'

RSpec.describe "アカウント削除機能", type: :system do
  # FactoryBotでユーザーを作成
  let!(:user) { FactoryBot.create(:user) }
  
  before do
    # ログイン処理
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "正常系" do
    it "アカウントを削除できること" do
      # 削除前のユーザ数を確認
      expect(User.count).to eq(1)
      
      # マイページをクリック
      click_link "マイページ"
      # プロフィール編集をクリック
      click_link "プロフィール編集"
      # プロフィール編集画面に遷移すること
      expect(page).to have_content("プロフィール編集")
      
      # アカウント削除ボタンをクリックし、確認ダイアログでOKを選択
      page.accept_confirm do
        click_button "アカウント削除"
      end
      
      # 1秒後に、（1秒待たないと、DBにユーザが残ったままでテストをパスしない為）
      sleep 1
      # DBからユーザーが削除されていることを確認
      expect(User.count).to eq(0)
      # TOP画面に遷移すること
      expect(current_path).to eq(root_path)
      # 以下のフラッシュメッセージが表示されること
      expect(page).to have_content("アカウントを削除しました。またのご利用をお待ちしております。")
    end
  end

  describe "異常系" do
    it "削除確認ダイアログでキャンセルした場合、削除されないこと" do
      # 事前にユーザ数を確認
      expect(User.count).to eq(1)
      
      # マイページをクリック
      click_link "マイページ"
      # プロフィール編集をクリック
      click_link "プロフィール編集"
      
      # キャンセルを選択
      page.dismiss_confirm do
      click_button "アカウント削除"
      end
      
      # ユーザーが削除されていないこと
      expect(User.count).to eq(1)
      # プロフィール編集画面であること
      expect(current_path).to eq(edit_user_registration_path)
    end
  end
end
