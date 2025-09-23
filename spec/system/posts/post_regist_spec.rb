require 'rails_helper'

RSpec.describe "投稿登録機能", type: :system do
  # ユーザを作成
  let!(:user) { create(:user) }
  
  # ログインする
  before do
    sign_in user
  end
  
  describe "書籍の新規投稿作成" do
    it "投稿が正常に作成されること" do
      # 新規投稿画面に遷移
      visit new_post_path

      # フォームに以下を入力
      fill_in "post[title]", with: "テストタイトル"
      fill_in "post[review_text]", with: "テストの本文です"
      select "⭐⭐⭐⭐⭐ (5) とても良い", from: "post[rating]"
      # 用意したテスト画像を取得
      test_image_path = Rails.root.join('spec', 'fixtures', 'test_image.jpg')
      # テスト画像を添付する
      attach_file "post[image]", test_image_path

      #   ボタンをクリック
      click_button "投稿する"
    
      # 以下のメッセージが表示されること
      expect(page).to have_content("投稿を作成しました")
      # 一覧画面に遷移すること
      visit posts_path
    end
  end

  describe "動画の新規投稿作成" do
    it "投稿が正常に作成されること" do
      # 新規投稿画面に遷移
      visit new_post_path
      
      # 投稿タイプで動画を選択
      choose "post_type_video"

      # フォームに以下を入力
      fill_in "post[title]", with: "テストタイトル"
      fill_in "post[review_text]", with: "テストの本文です"
      select "⭐⭐⭐⭐⭐ (5) とても良い", from: "post[rating]"
      fill_in "post[video_url]", with: "https://example.com/updated-video"
      
      #   ボタンをクリック
      click_button "投稿する"
    
      # 以下のメッセージが表示されること
      expect(page).to have_content("投稿を作成しました")
      # 一覧画面に遷移すること
      visit posts_path
    end
  end
end
