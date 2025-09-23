FactoryBot.define do
  # コメント定義
  factory :comment do
    comment_text { "テストコメント" }
    association :post
    association :user
  end
end

