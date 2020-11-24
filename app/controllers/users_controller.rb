class UsersController < ApplicationController
  # ログインユーザのみアクセス許可
  before_action :authenticate_user!
  # ゲストログイン情報の編集不可
  before_action :check_guest, only: [:update, :withdrawal]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を変更しました"
      redirect_to user_path(@user.id)
    else
      render 'edit'
    end
  end

  def post
    @user = User.find(params[:id])
    @users = Kaminari.paginate_array(@user.posts).page(params[:page]).per(20)
  end

  def like
    @user = User.find(params[:id])
    @users = Kaminari.paginate_array(@user.favorite_posts).page(params[:page]).per(10)
  end

  def withdrawal
    @user = User.find(params[:id])
    if @user.update(is_dleted: true)
      reset_session
      flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
      redirect_to root_path
    end
  end

  def check_guest
    if current_user.email == 'guest@guest.com'
      flash[:notice] = "ゲストユーザーは変更・退会できません"
      redirect_to user_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :age, :email)
  end
end
