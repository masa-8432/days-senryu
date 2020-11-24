class PostsController < ApplicationController

  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def index
    @posts = Post.all.order(updated_at: "DESC").page(params[:page]).per(10)
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
    @post = Kaminari.paginate_array(@post.favorited_users).page(params[:page]).per(20)
  end

  def ranking
    #日付を変数にいれる
    today = Date.today
    yesterday = today.ago(1.days)
    day_before_yesterday = today.ago(2.days)
    #それぞれの投稿日のいいね数が一番のものを取り出す
    @today = Post.find(Favorite.includes(:post).where(posts: { created_at: today.beginning_of_day..today.end_of_day }).group(:post_id).order('count(post_id) desc').limit(1).pluck(:post_id))
    @yesterday = Post.find(Favorite.includes(:post).where(posts: { created_at: yesterday.beginning_of_day..yesterday.end_of_day }).group(:post_id).order('count(post_id) desc').limit(1).pluck(:post_id))
    @day_before_yesterday =  Post.find(Favorite.includes(:post).where(posts: { created_at: day_before_yesterday.beginning_of_day..day_before_yesterday.end_of_day }).group(:post_id).order('count(post_id) desc').limit(1).pluck(:post_id))
  end

  def comment
    #コメントステータスがtrue（募集の投稿）を取り出す
    #最終編集瓶から２日たっているものは表示しないようにする（ステータスの切替はしない
    date = Date.today - 2
    @posts = Post.where(comment_status: true).where("updated_at >= '#{date}'").order(created_at: "DESC")
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
  end

  private
  def post_params
    params.require(:post).permit(:theme, :text, :comment_status)
  end

end
