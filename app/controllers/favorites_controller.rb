class FavoritesController < ApplicationController

  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    @posts = Post.all
    respond_to do |format|
      if favorite.save
        # format.js {render :template => "favorites/index", locals: {post: @post}}
        format.js {render locals: {post: @post}}
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    @posts = Post.all
    respond_to do |format|
      if favorite.destroy
        format.js {render locals: {post: @post}}
      end
    end
  end

end
