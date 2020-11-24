class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 他モデルとの関連付け
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  # バリデーション
  validates :name, presence: true
  validates :gender, presence: true
  validates :age, presence: true
  validates :email, presence: true

  # 性別をenumで管理
  enum gender: { '男性': 0, '女性': 1, 'その他': 2 }

  # 年齢をenumで管理
  enum age: { '10代': 0, '20代': 1, '30代': 2, '40代': 3, '50代': 4, '60代': 5, '70歳以上': 6 }

  # ログインするときに退会済のユーザーを弾く
  def active_for_authentication?
    super && (is_dleted == false)
  end

  # ゲストログインのアカウント
  def self.guest
    find_or_create_by!(name: 'ゲスト', email: 'guest@guest.com', gender: 0, age: 0) do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
