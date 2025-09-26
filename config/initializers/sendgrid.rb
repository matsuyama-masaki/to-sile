ActionMailer::Base.add_delivery_method :sendgrid_actionmailer, Mail::SendgridDeliveryMethod, {
  api_key: ENV['SENDGRID_API_KEY']
}
