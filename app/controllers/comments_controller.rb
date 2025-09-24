class CommentsController < ApplicationController
  # コメント作成、削除実行時にログインしていない場合、ログイン画面にリダイレクトする
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_post, only: [:create]
  before_action :set_comment_and_post, only: [:destroy]

  def create
    # 投稿に紐づくコメントを作成する
    @comment = @post.comments.build(comment_params)
    
    # コメントの投稿者を取得する
    @comment.user = current_user

    # コメントが保存できた場合
    if @comment.save

      respond_to do |format|
        # htmlリクエストの場合、フラッシュメッセージを表示して投稿詳細画面にリダイレクトする
        format.html { redirect_to post_path(@post), notice: 'コメントを投稿しました' }
        # turboの場合、turbo_stream形式でレスポンスを返す
        format.turbo_stream
      end
    else
      # エラー時はコメント一覧を更新せず、フォームのみ更新
      respond_to do |format|
        # htmlリクエストの場合、フラッシュメッセージを表示して投稿詳細画面にリダイレクトする
        format.html { redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました' }
        # turboの場合、エラーメッセージを表示してフォームを再表示する
        format.turbo_stream {render :create, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    # コメントを削除する
    @comment.destroy!

    respond_to do |format|
      # htmlリクエストの場合、フラッシュメッセージを表示して投稿詳細画面にリダイレクトする
      format.html { redirect_to post_path(@post), notice: 'コメントを削除しました' }
      # turboの場合、turbo_stream形式でレスポンスを返す
      format.turbo_stream
    end
  end

  private

  def set_post
    # 投稿IDを検索する
    @post = Post.find(params[:post_id])
  end

  def set_comment_and_post
    # ユーザIDに紐づくコメントを検索する
    @comment = current_user.comments.find(params[:id])
    # 投稿情報を保持する
    @post = @comment.post
  # コメント投稿者でない場合、トップページにリダイレクトし、エラーメッセージを表示する
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '権限がありません'
  end

  def comment_params
    # コメントのみを許可をする
    params.require(:comment).permit(:comment_text)
  end
end
