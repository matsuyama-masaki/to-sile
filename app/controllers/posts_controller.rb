class PostsController < ApplicationController
  # ログインしていない場合、投稿一覧、投稿詳細以外の画面遷移は、ログインを要求する
  before_action :authenticate_user!, except: %i[index show]

  # 詳細、編集、更新、削除のみ、事前にIDに基づいた投稿を検索する
  before_action :set_post, only: %i[show edit update destroy]

  # 編集、更新、削除時のみ投稿作成者チェックを実施する。
  before_action :check_owner, only: %i[edit update destroy]

  def index
    # 投稿日が新しい順で投稿を表示する（投稿数が13個以上で次ページに表示）
     @posts = @q.result(distinct: true)
                .includes(:user, :comments, image_attachment: :blob)
                .order(created_at: :desc)
                .page(params[:page])
                .per(12)
  end

  def new
    # 新規投稿フォームの表示をする
    @post = current_user.posts.build
    
    # デフォルト値を書籍に設定
    @post.post_type = 'book'
  end

  def create
    # 新規投稿を作成する
    @post = current_user.posts.build(post_params)
    
    # 入力した投稿内容を保存できたら、
    if @post.save
      # 投稿一覧画面にリダイレクトし、フラッシュメッセージを表示する
      redirect_to posts_path, notice: t('defaults.flash_message.created', item: Post.model_name.human)
    else
      # 保存できない場合、入力フォームを再表示する
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # 新規コメントフォームの表示をする
    @comment = Comment.new
    # コメントを投稿日の降順で表示する
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit
  end

  def update
    # 投稿を更新する
    if @post.update(post_params)
      # 更新できた場合、投稿詳細画面にリダイレクトし、フラッシュメッセージを表示する
      redirect_to @post, notice: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      # 更新できない場合、編集フォームを再表示する
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 投稿を削除できたら、
    @post.destroy!
    # 投稿一覧画面にリダイレクトし、フラッシュメッセージを表示する
    redirect_to posts_path, notice: t('defaults.flash_message.deleted', item: Post.model_name.human)
  end

  private

  def post_params
    # タイトル レビュー本文 投稿タイプ カテゴリ 画像 URL 星評価を許可する
    params.require(:post).permit(:title, :review_text, :post_type, :category, :image, :video_url, :rating)
  end

  def set_post
    # IDに基づいた投稿を検索する
    @post = Post.find(params[:id])
  end

  def check_owner
    # 投稿の作成者でない場合、一覧画面にリダイレクトし、エラーメッセージを表示する
    redirect_to posts_path, alert: '権限がありません。' unless current_user.own?(@post)
  end
end
