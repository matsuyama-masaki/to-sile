
require 'sendgrid-ruby'

module Mail
  class SendgridDeliveryMethod
    include SendGrid

    attr_accessor :settings

    def initialize(settings)
      @settings = settings
    end

    def deliver!(mail)
      Rails.logger.info "=== SendGrid Web API: メール送信開始 ==="
      
      begin
        # SendGridクライアント初期化
        sg = SendGrid::API.new(api_key: @settings[:api_key])
        
        # メール内容の構築
        from = Email.new(email: mail.from.first)
        to = Email.new(email: mail.to.first)
        subject = mail.subject
        content = Content.new(type: 'text/html', value: mail.body.to_s)
        
        # メールオブジェクト作成
        sendgrid_mail = SendGrid::Mail.new(from, subject, to, content)
        
        # API経由で送信
        response = sg.client.mail._('send').post(request_body: sendgrid_mail.to_json)
        
        Rails.logger.info "=== SendGrid Web API: レスポンス ==="
        Rails.logger.info "Status Code: #{response.status_code}"
        Rails.logger.info "Body: #{response.body}"
        Rails.logger.info "Headers: #{response.headers}"
        
        if response.status_code.to_i >= 200 && response.status_code.to_i < 300
          Rails.logger.info "=== SendGrid Web API: メール送信成功 ==="
        else
          Rails.logger.error "=== SendGrid Web API: メール送信失敗 ==="
          raise "SendGrid API Error: #{response.status_code}"
        end
        
        response
        
      rescue => e
        Rails.logger.error "=== SendGrid Web API: エラー ==="
        Rails.logger.error "エラー詳細: #{e.message}"
        raise e
      end
    end
  end
end
