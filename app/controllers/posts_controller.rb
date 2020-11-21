class PostsController < ApplicationController

  def index
    @posts = Post.all.order(updated_at: "DESC")
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿が完了しました"
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿内容を更新しました"
      redirect_to post_path(@post.id)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "投稿を削除しました"
      redirect_to posts_path
    end
  end

  def like
    @post = Post.find(params[:id])
  end

  def ranking
    @rank = Post.find(Favorite.group(:updated_at).order('count(post_id) desc').limit(1).pluck(:post_id))
  end

  private
  def post_params
    params.require(:post).permit(:theme, :text, :comment_status)
  end

end
