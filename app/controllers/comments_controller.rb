class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_post_for_create, only: [:create]
  before_action :set_comment_and_post, only: [:destroy]

  def create
    # before_action :set_post_for_create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save

      respond_to do |format|
        # htmlリクエストの場合
        format.html { redirect_to post_path(@post), notice: 'コメントを投稿しました' }
        # turboの場合
        format.turbo_stream
      end
    else
      # エラー時はコメント一覧を更新せず、フォームのみ更新
      respond_to do |format|
        # htmlリクエストの場合
        format.html { redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました' }
        # turboの場合
        format.turbo_stream {render :create, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    # before_action :set_comment_and_post
    @comment.destroy!

    respond_to do |format|
      # htmlリクエストの場合
      format.html { redirect_to post_path(@post), notice: 'コメントを削除しました' }
      # turboの場合
      format.turbo_stream
    end
  end

  private

  # 投稿IDに紐づく投稿を検索する
  def set_post_for_create
    @post = Post.find(params[:post_id])
  end

  def set_comment_and_post
    # ユーザIDに紐づくコメントを検索する
    @comment = current_user.comments.find(params[:id])
    # 投稿情報を保持する
    @post = @comment.post
  # コメント削除権限をチェック（コメント投稿者本人のみ）
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '権限がありません'
  end

  # コメントのみを許可をする
  def comment_params
    params.require(:comment).permit(:comment_text)
  end
end
