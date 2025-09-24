class ApplicationMailer < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME'] || 'noreply@to-sile-app.onrender.com'
  layout "mailer"
end
