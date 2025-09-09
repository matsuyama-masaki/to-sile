class Post < ApplicationRecord
  # バリデーション
  # タイトル
  validates :title,
            presence: true,
            length: {
            maximum: 30,
            too_long: "は%{count}文字以内で入力してください"
            }
  
  # レビュー本文
  validates :review_text,
            presence: true,
            length: { 
            maximum: 1000,
            too_long: "は%{count}文字以内で入力してください"
            }

  # YuTubeURL
  validates :video_url, presence: true, if: :video?
  
  # 画像
  validates :image, presence: true, if: :book?
  validate :image_validation

  # アソシエーション
  belongs_to :user

  # 画像アップロード（Active Storage）
  has_one_attached :image

  # 書籍 動画
  enum :post_type, { book: 0, video: 1 }

  # スキャル デイトレ スウィング
  enum :category, { scalping: 0, day: 1, swing: 2 }
  
  # YouTube関連のメソッド ここから
  # YouTubeのURLからVideo IDを抽出するメソッド
  def youtube_video_id

    # video_urlが空でない場合、nilを返す
    return nil if video_url.blank?
    
    # 意図しない空白を削除する
    normalized_url = video_url.strip

    # 以下のYouTubeのURL形式に対応
    patterns = [
      # 例：https://www.youtube.com/watch?v=xxxxxxxx
      /(?:https?:\/\/)?(?:www\.)?(?:m\.)?youtube\.com\/watch\?v=([^&\n?#]+)/,
      # 例：https://youtu.be/xxxxxxxxx
      /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([^&\n?#]+)/,
      # 例：https://www.youtube.com/embed/xxxxxxxx
      /(?:https?:\/\/)?(?:www\.)?(?:m\.)?youtube\.com\/embed\/([^&\n?#]+)/,
      # 例：youtube.com/v/xxxxxxxx
      /(?:https?:\/\/)?(?:www\.)?(?:m\.)?youtube\.com\/v\/([^&\n?#]+)/
    ]
    
    # 上記とマッチした場合、動画IDを返す
    patterns.each do |pattern|
      match = video_url.match(pattern)
      return match[1] if match
    end

    nil
  end

  # YouTubeサムネイル画像のURLを生成するメソッド
  def youtube_thumbnail_url(quality: 'maxresdefault')
    
    # youtube_video_idが存在しない場合、nilを返す
    return nil if youtube_video_id.blank?
    
    # キャッシュキーを生成
    cache_key = "youtube_thumbnail_#{youtube_video_id}_#{quality}"

    # キャッシュから取得、なければ生成してキャッシュに保存
    Rails.cache.fetch(cache_key, expires_in: 1.day) do

    # 動画のサムネイル画像を取得するAPI
      "https://img.youtube.com/vi/#{youtube_video_id}/#{quality}.jpg"
    end
  end

  # YouTubeの埋め込み用URLを生成するメソッド
  def youtube_embed_url

    # youtube_video_idが存在しない場合、nilを返す
    return nil if youtube_video_id.blank?

    # キャッシュキーを生成
    cache_key = "youtube_embed_url_#{youtube_video_id}_v1"

    # キャッシュから取得、なければ生成してキャッシュに保存
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      "https://www.youtube.com/embed/#{youtube_video_id}"
    end
  end
  # YouTube関連のメソッド ここまで

  private

  # 画像のバリデーションメソッド
  def image_validation
    return unless image.attached?

    # ファイルサイズが5M以上の場合のエラーメッセージ
    if image.byte_size > 5.megabytes
        errors.add(:image, 'のサイズは5MB以下にしてください')
    end

    # ファイルの形式がJPEG, JPG, PNG, GIFでない場合にだすエラーメッセージ
    acceptable_types = %w[image/jpeg image/jpg image/png image/gif]
    unless acceptable_types.include?(image.content_type)
        errors.add(:image, 'は JPEG, JPG, PNG, GIF 形式のみアップロード可能です')
    end
  end

  # Ransackで検索可能な属性を定義
  def self.ransackable_attributes(auth_object = nil)
    %w[title review_text category post_type created_at]
  end
  # Ransackでユーザ名、emailでも検索できるアソシエーションを定義
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
