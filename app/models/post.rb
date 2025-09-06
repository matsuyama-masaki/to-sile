class Post < ApplicationRecord
  # バリデーション
  validates :title, presence: true, length: { maximum: 255 }
  validates :review_text, presence: true, length: { maximum: 65_535 }
  validates :post_type, inclusion: { in: %w[book video] }
  validates :category, presence: true
  validate :image_validation
  validates :video_url, presence: true, if: :video?
  validates :image, presence: true, if: :book?

  # アソシエーション
  belongs_to :user

  # 画像アップロード（Active Storage）
  has_one_attached :image

  # 書籍 動画
  enum :post_type, { book: 0, video: 1 }

  # スキャル デイトレス ウィング
  enum :category, { scalping: 0, day: 1, swing: 2 }
  
  # YouTube関連のメソッド ここから
  # YouTubeのURLからVideo IDを抽出するメソッド
  def youtube_video_id
    return nil if video_url.blank?
    
    normalized_url = video_url.strip

    # 様々なYouTubeのURL形式に対応
    patterns = [
      /(?:https?:\/\/)?(?:www\.)?(?:m\.)?youtube\.com\/watch\?v=([^&\n?#]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([^&\n?#]+)/,
      /(?:https?:\/\/)?(?:www\.)?(?:m\.)?youtube\.com\/embed\/([^&\n?#]+)/,
      /(?:https?:\/\/)?(?:www\.)?(?:m\.)?youtube\.com\/v\/([^&\n?#]+)/
    ]

    patterns.each do |pattern|
      match = video_url.match(pattern)
      return match[1] if match
    end

    nil
  end

  # YouTubeサムネイル画像のURLを生成するメソッド
  def youtube_thumbnail_url(quality: 'maxresdefault')
    return nil unless youtube_video_id.present?

    "https://img.youtube.com/vi/#{youtube_video_id}/#{quality}.jpg"
  end

  # 埋め込み用のYouTube URLを生成するメソッド
  def youtube_embed_url
    return nil unless youtube_video_id.present?

    "https://www.youtube.com/embed/#{youtube_video_id}"
  end
  # YouTube関連のメソッド ここまで

  private

  # 画像のバリデーションメソッド
  def image_validation
    return unless image.attached?

    # ファイルサイズの確認
    if image.byte_size > 5.megabytes
        errors.add(:image, 'のサイズは5MB以下にしてください')
    end

    # ファイルの形式の確認
    acceptable_types = %w[image/jpeg image/jpg image/png image/gif]
    unless acceptable_types.include?(image.content_type)
        errors.add(:image, 'は JPEG, JPG, PNG, GIF 形式のみアップロード可能です')
    end
  end

  # Ransackで検索可能な属性を定義
  def self.ransackable_attributes(auth_object = nil)
    %w[title review_text category post_type created_at updated_at]
  end
  
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
