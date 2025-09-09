Rails.application.routes.draw do
  # top画面へのルーティング
  root 'static_pages#top'
  
  # ユーザー認証関連のルーティング
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # 投稿関連のルーティング
  resources :posts, only: %i[index new create show edit update destroy]

# 開発環境でのみletter_opener_webをマウント
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # ヘルスチェック用エンドポイント
  get "up" => "rails/health#show", as: :rails_health_check

  # pwa関連のルーティング
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

