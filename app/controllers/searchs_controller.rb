class SearchsController < ApplicationController

  # ログインユーザのみアクセス許可
  before_action :authenticate_user!

  def search

    # 検索対象のモデル："User","Post"
    @model = params["model"]
    # 検索ワード
    @content = params["content"]

    if @model == "Post"
      @themes = partical_theme(@content).page(params[:page]).per(10)
      if @themes.count == 0
        flash.now[:alert] = "該当する投稿は見つかりませんでした。"
      end
      render "index"
    elsif
      @model == "Post"
      @texts = partical_text(@content).page(params[:page]).per(10)
      if @texts.count == 0
        flash.now[:alert] = "該当する投稿は見つかりませんでした。"
      end
      render "index"
    else
      @model == "Post"
      @users = partical_user(@content).page(params[:page]).per(10)
      if @users.count == 0
        flash.now[:alert] = "該当する投稿は見つかりませんでした。"
      end
      render "index"
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
      Post.left_outer_joins(:user).where("user.name LIKE ?", "%#{content}%")
  end


end
