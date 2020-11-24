class Favorite < ApplicationRecord
  # 他モデルとの関連付け
  belongs_to :user
  belongs_to :post
end
