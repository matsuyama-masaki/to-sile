class User < ApplicationRecord
  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # バリデーション
  validates :name, presence: true

  # 権限定義
  enum :role, [:user, :admin]

  # 新規登録時にuser権限を付与する
  after_initialize :set_default_role, if: :new_record?

  # user権限付与するメソッド
  def set_default_role
    self.role ||= :user
  end

  # ログインユーザのidと投稿作成者のidをチェックするメソッド
  def own?(object)
    id == object&.user_id
  end

  # Include default devise modules. Others available are:
  # :lockable, :trackable and :omniauthable
  # deviceで利用する機能
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :confirmable
end
