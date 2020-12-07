class PostComment < ApplicationRecord
  # 他モデルとの関連付け
  belongs_to :user
  belongs_to :post

  # バリデーション
  validates :comment, presence: true

end
