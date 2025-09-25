class ApplicationMailer < ActionMailer::Base
  # 送信元アドレスの設定
  default from: ENV['SENDER_ADDRESS'] || 'noreply@to-sile-app.onrender.com'
  layout "mailer"
end
