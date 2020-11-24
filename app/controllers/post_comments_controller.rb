class PostCommentsController < ApplicationController
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    console.log("create")
    respond_to do |format|
      if comment.save
        # format.js {render :template => "favorites/index", locals: {post: @post}}
        format.js { render locals: { post: post, comment: comment } }
        flash[:notice] = "コメントを投稿しました"
      else
        render '/posts/show'
      end
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
    if PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
      flash[:notice] = "コメントを削除しました"
      redirect_to post_path(params[:post_id])
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
