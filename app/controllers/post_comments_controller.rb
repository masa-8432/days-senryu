class PostCommentsController < ApplicationController
  
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save
      flash[:notice] = "コメントの投稿が完了しました"
      redirect_to request.referer
    end
  end

  def update

  end

  def destroy
    if PostComment.find_by(id:params[:id], post_id: params[:post_id]).destroy
      flash[:notice] = "コメントを削除しました"
      redirect_to post_path(params[:post_id])
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
