class Comment < ApplicationRecord
  # アノテーション
  belongs_to :user
  belongs_to :post

  # バリデーション
  validates :comment_text, presence: true, length: { maximum: 65535 }

  # コメント投稿者かどうかをチェック
  def own_comment?(current_user)
    user_id == current_user&.id
  end
end
