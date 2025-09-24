# frozen_string_literal: true
class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    super do |resource|
      # パスワードリセット申請時にバリデーションエラーをフラッシュメッセージに変換
      if resource.errors.any?
        flash.now[:danger] = resource.errors.full_messages.join(', ')
      end
    end

    Rails.logger.info "=== パスワードリセット詳細ログ開始 ==="
    Rails.logger.info "送信先メールアドレス: #{params[:user][:email]}"
    Rails.logger.info "SMTP設定確認完了"
  
  begin
    start_time = Time.current
    Rails.logger.info "メール送信開始時刻: #{start_time}"
    
    # Devise のパスワードリセット処理
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    
    end_time = Time.current
    Rails.logger.info "メール送信処理完了: #{end_time}"
    Rails.logger.info "処理時間: #{(end_time - start_time).round(2)}秒"
    
    if successfully_sent?(resource)
      Rails.logger.info "✅ メール送信成功"
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      Rails.logger.error "❌ メール送信失敗"
      Rails.logger.error "エラー内容: #{resource.errors.full_messages}"
      respond_with(resource)
    end
    
  rescue Net::OpenTimeout => e
    Rails.logger.error "=== SMTP接続タイムアウト ==="
    Rails.logger.error "エラー: #{e.message}"
    Rails.logger.error "原因: smtp.gmail.com:587 への接続がタイムアウト"
    Rails.logger.error "=========================="
    
    flash[:alert] = "メール送信でタイムアウトが発生しました。しばらく時間をおいて再度お試しください。"
    redirect_to new_user_password_path
    
  rescue Net::SMTPAuthenticationError => e
    Rails.logger.error "=== SMTP認証エラー ==="
    Rails.logger.error "エラー: #{e.message}"
    Rails.logger.error "原因: ユーザー名またはアプリパスワードが無効"
    Rails.logger.error "=========================="
    
    flash[:alert] = "メール認証に失敗しました。設定を確認してください。"
    redirect_to new_user_password_path
    
  rescue Net::SMTPServerBusy => e
    Rails.logger.error "=== SMTPサーバービジー ==="
    Rails.logger.error "エラー: #{e.message}"
    Rails.logger.error "原因: Gmailサーバーが混雑中"
    Rails.logger.error "=========================="
    
    flash[:alert] = "メールサーバーが混雑しています。しばらく時間をおいて再度お試しください。"
    redirect_to new_user_password_path
    
  rescue => e
    Rails.logger.error "=== その他のメールエラー ==="
    Rails.logger.error "エラークラス: #{e.class}"
    Rails.logger.error "エラーメッセージ: #{e.message}"
    Rails.logger.error "バックトレース: #{e.backtrace.first(5)}"
    Rails.logger.error "=========================="
    
    flash[:alert] = "メール送信中にエラーが発生しました: #{e.message}"
    redirect_to new_user_password_path
  end
  
  Rails.logger.info "=== パスワードリセット詳細ログ終了 ==="
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super do |resource|
      # パスワードリセット更新時にバリデーションエラーをフラッシュメッセージに変換
      if resource.errors.any?
        flash.now[:danger] = resource.errors.full_messages.join(', ')
      end
    end
  end

  # protected
  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
