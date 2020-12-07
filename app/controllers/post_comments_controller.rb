class PostCommentsController < ApplicationController
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    # APIにリクエスト送信
    @comment.score = Language.get_data(post_comment_params[:comment])
    if @comment.save
      @comment = PostComment.new
      flash.now[:notice] = "コメントを投稿しました"
    else
      render '/posts/show'
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = PostComment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = PostComment.find(params[:id])
    if @comment.update(post_comment_params)
      flash[:notice] = "コメントを更新しました"
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = PostComment.find_by(id: params[:id], post_id: @post.id)
    if @comment.destroy
      @comment = PostComment.new
      flash.now[:notice] = "コメントを削除しました"
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
