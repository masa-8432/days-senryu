class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments
  has_many :favorites

end
