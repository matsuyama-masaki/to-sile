class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # デバイスの場合、ストロングパラメータをチェックする
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # 検索するパラメータ
  before_action :set_search

  # ActiveStorage用のURL設定
  before_action :set_current_url_options

  # サインイン後にリダイレクトするパスを指定
  def after_sign_in_path_for(resource)
    posts_path
  end
  
  # アカウント登録後にリダイレクトするパスを指定
  def after_sign_up_path_for(resource)
    posts_path
  end

  # 検索するパラメータを受け取って代入するメソッド
  def set_search
    @q = Post.ransack(params[:q])
  end

  protected
  # ストロングパラメータ
  def configure_permitted_parameters
    # サインアップで、name、email、passwodを許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    
    # パスワードリセットで、name、email、passwodを許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # ActiveStorageのURLを設定するメソッド
  def set_current_url_options
    ActiveStorage::Current.url_options = {
      host: request.host,
      port: request.port,
      protocol: request.protocol
    }
  end
end

