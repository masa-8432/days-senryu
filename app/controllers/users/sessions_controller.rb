# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def new_guest
    user = User.guest
    if sign_in user
      flash[:notice] = "ゲストユーザーとしてログインしました"
      redirect_to posts_path
    else
      render 'new_guest'
    end
  end

  def after_sign_in_path_for(resource)
    posts_path
  end

  before_action :reject_user, only: [:create]

  protected

  def reject_user
    @user = User.find_by(email: params[:user][:email])
    if @user
      if (@user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false ))
        flash[:notice] = "退会済みのユーザーです"
        redirect_to new_user_session_path
      end
    else
    end
  end

end
