class PostsController < ApplicationController
  # 投稿一覧、投稿詳細以外の画面遷移は、ログインを要求する
  before_action :authenticate_user!, except: %i[index show]

  # 詳細、編集、更新、削除のみ、事前にIDに基づいた投稿を検索する
  before_action :set_post, only: %i[show edit update destroy]

  # 編集、更新、削除時のみ投稿作成者チェックを実施する。
  before_action :check_owner, only: %i[edit update destroy]

  def index
    # 投稿日が新しい順で一覧を表示する
     @posts = @q.result(distinct: true)
                .includes(:user, image_attachment: :blob)
                .order(created_at: :desc)
                .page(params[:page])
                .per(12)
  end

  def new
    # 投稿の入力フォームを表示する
    @post = current_user.posts.build
    
    # デフォルト値を書籍に設定
    @post.post_type = 'book'
  end

  def create
    @post = current_user.posts.build(post_params)
    
    # 入力した投稿内容を保存できたら、一覧を表示する
    if @post.save
      redirect_to posts_path, notice: t('defaults.flash_message.created', item: Post.model_name.human)
    else
      # 保存できない場合、入力フォームを再表示する
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # set_postのbefore_actionで設定済み
  end

  def edit
    # set_postのbefore_actionで設定済み
  end

  def update
    # 投稿を更新する
    if @post.update(post_params)
      redirect_to posts_path, notice: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      # 更新できない場合、編集フォームを再表示する
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 投稿を削除する
    @post.destroy
    redirect_to posts_path, notice: t('defaults.flash_message.deleted', item: Post.model_name.human)
  end

  private

  # タイトル レビュー本文 投稿タイプ カテゴリ 画像 URLを許可する
  def post_params
    params.require(:post).permit(:title, :review_text, :post_type, :category, :image, :video_url)
  end

  # IDに基づいた投稿を検索する
  def set_post
    @post = Post.find(params[:id])
  end

  # 投稿の作成者でない場合、アラートを出力するメソッド
  def check_owner
    redirect_to posts_path, alert: '権限がありません。' unless current_user.own?(@post)
  end
end
