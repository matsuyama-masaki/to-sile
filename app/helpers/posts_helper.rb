module PostsHelper
  # サムネイルの処理
  def youtube_thumbnail_image(post, size: :medium, **options)
    return unless post.youtube_video_id

    # サムネイルの設定
    quality = case size
    when :small then 'mqdefault'     # 320x180
    when :medium then 'hqdefault'    # 480x360
    when :large then 'maxresdefault' # 1280x720
    end

    thumbnail_url = post.youtube_thumbnail_url(quality: quality)

    image_tag thumbnail_url,
              alt: "#{post.title} - YouTube動画",
              class: options[:class] || 'youtube-thumbnail',
              **options
  end

  # 詳細画面の埋め込み動画の処理
  def youtube_embed_with_thumbnail(post, **options)
    return unless post.youtube_video_id

    content_tag :div, class: 'youtube-embed-container' do
      if options[:show_thumbnail]
        # サムネイル表示（クリックで動画再生）
        link_to post.youtube_embed_url,
                target: '_blank',
                class: 'youtube-thumbnail-link' do
          youtube_thumbnail_image(post, **options)
        end
      else
        # 直接埋め込み
        content_tag :iframe, 
                    nil, 
                    src: post.youtube_embed_url, 
                    width: options[:width] || 560, 
                    height: options[:height] || 315, 
                    frameborder: 0,
                    allowfullscreen: true
      end
    end
  end

  # 投稿日表示処理
  def formatted_post_date(post)
    post.created_at.strftime("%Y年%m月%d日 %H:%M")
  end
end
