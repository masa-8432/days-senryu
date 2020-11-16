class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :post_comments
  has_many :favotites

  # 性別をenumで管理
  enum gender: {'男性': 1, '女性': 2, 'その他': 3}

  # 年齢をenumで管理
  enum age: { '10代':0, '20代':1, '30代':2, '40代':4, '50代':4, '60代':5, '70歳以上':6 }

end
