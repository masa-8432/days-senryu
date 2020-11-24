class Post < ApplicationRecord

  # 他モデルとの関連付け
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  # バリデーション
  validates :theme, presence: true
  validates :text, presence: true


  # 投稿に対していいねが存在しているか
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
