# frozen_string_literal: true
class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    super do |resource|
      # パスワードリセット申請時にバリデーションエラーをフラッシュメッセージに変換して表示
      if resource.errors.any?
        flash.now[:danger] = resource.errors.full_messages.join(', ')
      end
    end

    Rails.logger.info "=== SendGrid パスワードリセット開始 ==="
  Rails.logger.info "送信先: #{params[:user][:email]}"
  Rails.logger.info "SENDGRID_API_KEY設定: #{ENV['SENDGRID_API_KEY'].present? ? 'あり' : 'なし'}"
  
  begin
    start_time = Time.current
    Rails.logger.info "SendGrid経由でメール送信開始: #{start_time}"
    
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    
    end_time = Time.current
    Rails.logger.info "SendGrid送信完了: #{end_time}"
    Rails.logger.info "送信時間: #{(end_time - start_time).round(2)}秒"
    
    if successfully_sent?(resource)
      Rails.logger.info "✅ SendGrid送信成功"
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      Rails.logger.error "❌ SendGrid送信失敗: #{resource.errors.full_messages}"
      respond_with(resource)
    end
    
  rescue => e
    Rails.logger.error "=== SendGridエラー ==="
    Rails.logger.error "エラークラス: #{e.class}"
    Rails.logger.error "エラーメッセージ: #{e.message}"
    Rails.logger.error "========================"
    
    flash[:alert] = "メール送信中にエラーが発生しました。しばらく時間をおいて再度お試しください。"
    redirect_to new_user_password_path
  end
  
  Rails.logger.info "=== SendGrid パスワードリセット終了 ==="
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super do |resource|
      # パスワードリセット更新時にバリデーションエラーをフラッシュメッセージに変換して表示
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
