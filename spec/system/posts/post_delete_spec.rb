require 'rails_helper'

RSpec.describe "投稿削除機能", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user, title: "削除テスト投稿") }
  
  before do
    sign_in user
  end
  
  describe "確認ダイアログ付き削除" do
    it "確認ダイアログが表示され、OKで削除されること" do
      # 詳細画面に遷移
      visit post_path(post)
      
      # 確認ダイアログで削除を選択
      accept_confirm("本当に削除しますか？") do
        click_link "削除"
      end
      
      # 以下のメッセージが表示されること
      expect(page).to have_content("投稿を削除しました")
      # 投稿一覧画面に遷移すること
      expect(current_path).to eq(posts_path)
      
    end
    
    it "確認ダイアログでキャンセルした場合、削除されないこと" do
      # 詳細画面に遷移
      visit post_path(post)
      
      # 確認ダイアログでキャンセルを選択
      dismiss_confirm("本当に削除しますか？") do
        click_link "削除"
      end
      
      # 投稿が残っていることを確認
      expect(page).to have_content("削除テスト投稿")
    end
  end
end
