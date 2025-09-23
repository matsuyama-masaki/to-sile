FactoryBot.define do
  # ベースの投稿
  factory :post do
    title { "テストタイトル" }
    review_text { "これはテスト投稿のレビュー本文です。" }
    rating { 3 }
    post_type { :book }
    category { :scalping }
    video_url { nil }
    association :user
    
    # 画像を添付
    after(:build) do |post|
      if post.book?
        post.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'test_image.jpg')),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
    
    # 動画投稿用
    trait :video do
      post_type { :video }
      video_url { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
      
      after(:build) do |post|
        post.image.detach if post.image.attached?
      end
    end
    
    # 画像付き投稿用
    trait :with_image do
      after(:build) do |post|
        post.image.attach(
          io: StringIO.new("dummy image content"),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    # 書籍投稿用
    trait :book do
      post_type { :book }
      video_url { nil }
    end
    
    # カテゴリ別
    trait :day_trading do
      category { :day }
    end
    
    trait :swing_trading do
      category { :swing }
    end
    
    # コメント付き
    trait :with_comments do
      after(:create) do |post|
        create_list(:comment, 3, post: post)
      end
    end
  end
end
