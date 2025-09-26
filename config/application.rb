require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    
    # 全環境共通のメール設定
    config.action_mailer.default_options = {
    from: 'noreply@example.com'
    }
    
    # タイムゾーン（全環境で日本時間）
    config.time_zone = 'Tokyo'

    # Active Storageとmini_magick連携の設定
    config.active_storage.variant_processor = :mini_magick
    
    # 日本語をデフォルトロケールに設定
    config.i18n.default_locale = :ja
    
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << %W(#{config.root}/lib)
  end
end
