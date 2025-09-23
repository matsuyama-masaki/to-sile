require 'rails_helper'

RSpec.describe "コメント作成・削除機能", type: :system do
  # テストデータの作成
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:my_comment) { create(:comment, post: post, user: user, comment_text: "自分のコメント") }
  let!(:other_comment) { create(:comment, post: post, user: other_user, comment_text: "他人のコメント") }
  
  before do
    sign_in user
  end
  
  describe "コメント投稿機能" do
    context "有効なコメントを投稿する場合" do
      it "コメントが正常に投稿されること" do
        # 詳細画面に遷移
        visit post_path(post)
        
        # コメント数の変化を確認
        expect {
          fill_in "comment[comment_text]", with: "テストコメントです"
          click_button "ポスト"
          sleep 1
        }.to change(Comment, :count).by(1)
        
        # 投稿されたコメントが表示されることを確認
        expect(page).to have_content("テストコメントです")
        expect(page).to have_content(user.name)
      end
    end
  end

  describe "コメント削除ボタンの表示" do
    it "自分のコメントには編集・削除ボタンが表示されること" do
      # 詳細画面に遷移
      visit post_path(post)
      
      within "#comment-#{my_comment.id}" do
        # ゴミ箱アイコンが存在すること
        expect(page).to have_css("i.bi-trash3")
      end
    end
    
    it "他人のコメントには編集・削除ボタンが表示されないこと" do
      # 詳細画面に遷移
      visit post_path(post)
      
      within "#comment-#{other_comment.id}" do
        # ゴミ箱アイコンが存在しないこと
        expect(page).not_to have_css("i.bi-trash3")
      end
    end
  end
end
