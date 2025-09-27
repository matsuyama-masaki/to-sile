class ApplicationMailer < ActionMailer::Base
  # 送信元アドレスの設定
  default from: Rails.application.credentials.dig(:sendgrid, :from_email)
  layout "mailer"
end
