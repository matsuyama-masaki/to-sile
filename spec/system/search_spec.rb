require 'rails_helper'

RSpec.describe "検索機能", type: :system do
  # テストデータ作成
  let!(:post1) { create(:post, title: "Rubyについて", review_text: "Rubyについて") }
  let!(:post2) { create(:post, title: "Railsについて", review_text: "Railsについて") }
  let!(:post3) { create(:post, title: "JavaScriptについて", review_text: "JavaScriptについて") }

  before do
    # 一覧画面に遷移
    visit posts_path
  end

  it "タイトルで検索できること" do
    # Rubyを検索フォームに入力
    fill_in "q[title_or_review_text_cont]", with: "Ruby"
    # 検索ボタンをクリック
    find(".custom-search-btn").click
    
    # 以下が検索できること
    expect(page).to have_content("Rubyについて")
    # 以下が検索できないこと
    expect(page).not_to have_content("Railsについて")
    # 以下が検索できないこと
    expect(page).not_to have_content("JavaScriptについて")
  end

  it "内容で検索できること" do
    # Railsを検索フォームに入力
    fill_in "q[title_or_review_text_cont]", with: "Rails"
    # 検索ボタンをクリック
    find(".custom-search-btn").click
    
    # 以下が検索できること
    expect(page).to have_content("Railsについて")
    # 以下が検索できないこと
    expect(page).not_to have_content("Rubyについて")
  end

  it "検索結果が0件の場合の表示" do
    # 存在しないキーワードを検索フォームに入力
    fill_in "q[title_or_review_text_cont]", with: "存在しないキーワード"
    # 検索ボタンをクリック
    find(".custom-search-btn").click
    
    # 以下のメッセージが表示されること
    expect(page).to have_content("0件中 1-0件を表示")
  end
end
