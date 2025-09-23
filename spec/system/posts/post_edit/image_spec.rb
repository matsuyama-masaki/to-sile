require 'rails_helper'

RSpec.describe "投稿編集機能（画像のみ）", type: :system do
  # ユーザーを作成
  let!(:user) { create(:user) }
  # テストデータの作成
  let!(:book_post_with_image) { create(:post, :book, :with_image, user: user) }
  # サインインする
  before do
    sign_in user
  end

  it "画像を変更できること" do
    # 編集画面に遷移
    visit edit_post_path(book_post_with_image)
    
    # 用意したテスト画像を取得
    test_image_path = Rails.root.join('spec', 'fixtures', 'test_image.jpg')

    # テスト画像を添付する
    attach_file "post[image]", test_image_path
    
    click_button "更新する"
    # 以下のメッセージが表示されること
    expect(page).to have_content("投稿を更新しました")
  end
end
