class SearchsController < ApplicationController
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def search
    @posts = Post.all
    # 検索対象のモデル："User","Post"
    @type = params["model"]
    # 検索ワード
    @content = params["content"]
    if @type == "theme"
      @posts = partical_theme(@content).page(params[:page]).per(10)
      if @posts.count == 0
        flash.now[:notice] = "該当する投稿は見つかりませんでした。"
      end
      render "/posts/index"
    elsif @type == "text"
      @posts = partical_text(@content).page(params[:page]).per(10)
      if @posts.count == 0
        flash.now[:notice] = "該当する投稿は見つかりませんでした。"
      end
      render "/posts/index"
    elsif @type == "user"
      @posts = partical_user(@content).page(params[:page]).per(10)
      if @posts.count == 0
        flash.now[:notice] = "該当する投稿は見つかりませんでした。"
      end
      render "/posts/index"
    else
      render "/posts/index"
    end
  end

  private

  # お題検索
  def partical_theme(content)
    Post.where("theme LIKE ?", "%#{content}%")
  end

  # 本文検索
  def partical_text(content)
    Post.where("text LIKE ?", "%#{content}%")
  end

  # 投稿者検索
  def partical_user(content)
    Post.left_outer_joins(:user).where("name LIKE ?", "%#{content}%")
  end
  
end
