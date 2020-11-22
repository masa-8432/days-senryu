class PostsController < ApplicationController
  
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

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
    # ToDo
    # select A.id, A.theme, A.text, B.count 　最終的に表示するデータ
    #from posts AS A left join (select count(*) as count, post_id from favorites group by post_id) AS B 　この中から
    #on A.id = B.post_id where date(A.updated_at) = date(current_timestamp)  order by count desc;　　　　これを取り出して
[]
    #@rank = Post.find(Post.group(:updated_at).order('count(post_id) desc').limit(1).pluck(:post_id))
    #postとfavoriteを結合して、今日の投稿のものを取り出す
    today = Date.today
    yesterday = today.ago(1.days)
    day_before_yesterday = today.ago(2.days)
    @today = Post.find(Favorite.includes(:post).where(posts: { created_at: today.beginning_of_day..today.end_of_day }).group(:post_id).order('count(post_id) desc').limit(1).pluck(:post_id))
    @yesterday = Post.find(Favorite.includes(:post).where(posts: { created_at: yesterday.beginning_of_day..yesterday.end_of_day }).group(:post_id).order('count(post_id) desc').limit(1).pluck(:post_id))
    @day_before_yesterday =  Post.find(Favorite.includes(:post).where(posts: { created_at: day_before_yesterday.beginning_of_day..day_before_yesterday.end_of_day }).group(:post_id).order('count(post_id) desc').pluck(:post_id))
    # @posts = Post.joins(:favorite).where(Post.updated_at.to_s.match(/#{Date.today.to_s}.+/))
    # @post = @posts.find(Post.group(:post.id).order('count(post_id) desc').limit(1).pluck(:post.id))


    # where date(current_timestamp,'-2 days') <= date(A.updated_at) and comment_status = 1  order by count desc;
  end

  private
  def post_params
    params.require(:post).permit(:theme, :text, :comment_status)
  end

end
