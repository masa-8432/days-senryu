class UsersController < ApplicationController

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
  end

  def like
    @user = User.find(params[:id])
  end

  def withdrawal
    @user = User.find(params[:id])
    if @user.update(is_dleted: true)
      reset_session
      flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :age, :email)
  end

end
