class ApplicationMailer < ActionMailer::Base
  # 送信元アドレスの設定
  default from: ENV['FROM_EMAIL'] || 'noreply@to-sile-app.onrender.com'
  layout "mailer"
end
