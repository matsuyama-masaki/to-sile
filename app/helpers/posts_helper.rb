module PostsHelper
  # サムネイルの処理
  def youtube_thumbnail_image(post, size: :medium, **options)
    # youtube_video_idでない場合は何も返さない
    return unless post.youtube_video_id
    # サムネイル画質の設定
    quality = case size
    when :small then 'mqdefault'     # 320x180
    when :medium then 'hqdefault'    # 480x360
    when :large then 'maxresdefault' # 1280x720
    end
    # サムネイルURLを取得
    thumbnail_url = post.youtube_thumbnail_url(quality: quality)
    # image_tagを生成
    image_tag thumbnail_url,
      alt: "#{post.title} - YouTube動画",
      class: options[:class] || 'youtube-thumbnail',
      **options
  end

  # 詳細画面の埋め込み動画を表示する処理
  def youtube_embed_with_thumbnail(post, **options)
    # youtube_video_idでない場合は何も返さない
    return unless post.youtube_video_id
    # youtubeコンテンツを包むdivを作成
    content_tag :div, class: 'youtube-embed-container' do
    # 動画を埋め込みコードを返す
    content_tag :iframe, 
      nil, 
      src: post.youtube_embed_url, 
      width: options[:width] || 560, 
      height: options[:height] || 315, 
      frameborder: 0,
      allowfullscreen: true
    end
  end

  # 投稿日表示処理
  def formatted_post_date(post)
    post.created_at.strftime("%Y年%m月%d日 %H:%M")
  end

  # コメント日時表示処理
  def formatted_comment_date(comment)
    comment.created_at.strftime("%Y年%m月%d日 %H:%M")
  end
end
