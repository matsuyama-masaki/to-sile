require 'rails_helper'

RSpec.describe "投稿編集機能", type: :system do
  let!(:user) { create(:user) }
  
  before do
    sign_in user
  end

  describe "書籍の編集" do
    # テストデータを作成
    let!(:book_post) { create(:post, :book, user: user) }
    
    it "書籍投稿を正常に編集できること" do
    #   編集画面に遷移
      visit edit_post_path(book_post)
      
      # タイトル、感想、評価を更新
      fill_in "post[title]", with: "更新した書籍タイトル"
      fill_in "post[review_text]", with: "更新したレビュー内容"
      select "⭐⭐⭐⭐⭐ (5) とても良い", from: "post[rating]"

      click_button "更新する"

      # 以下のメッセージが表示されること
      expect(page).to have_content("投稿を更新しました")
      # 詳細画面に遷移すること
      expect(current_path).to eq post_path(book_post)
    end
  end

  describe "動画の編集" do
    # テストデータを作成
    let!(:video_post) { create(:post, :video, user: user) }
    
    it "動画投稿を正常に編集できること" do
      #   編集画面に遷移
      visit edit_post_path(video_post)

      # タイトル、URL、感想、評価を更新
      fill_in "post[title]", with: "更新された動画タイトル"
      fill_in "post[video_url]", with: "https://example.com/updated-video"
      fill_in "post[review_text]", with: "更新されたレビュー内容"
      select "⭐⭐⭐⭐⭐ (5) とても良い", from: "post[rating]"

      click_button "更新する"
      
      # 以下のメッセージが表示されること
      expect(page).to have_content("投稿を更新しました")
      # 詳細画面に遷移すること
      expect(current_path).to eq post_path(video_post)
    end
  end
end
