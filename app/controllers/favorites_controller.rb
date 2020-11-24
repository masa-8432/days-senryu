class FavoritesController < ApplicationController
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    @posts = Post.all
    favorite.save

  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    @posts = Post.all
    favorite.destroy
  end

end
