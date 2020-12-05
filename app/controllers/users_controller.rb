class UsersController < ApplicationController
  before_action :get_user, :correct_user, only: %i(edit update)

  def new
    @user = User.new
    @user.build_user_detail
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:info] = t "message.user.create_success"
      redirect_to root_url
    else
      flash.now[:danger] = t "message.user.create_fail"
      render :new
    end
  end

  def edit
    @user.build_user_detail if @user.user_detail.blank?
  end

  def update
    if @user.update user_params
      flash[:success] = t "message.user.update_success"
      redirect_to root_path
    else
      flash.now[:danger] = t "message.user.update_fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def get_user
    @user = User.find_by id: params[:id]
    return if @user

    flash.now[:danger] = t "message.user.not_found"
    redirect_to users_url
  end

  def correct_user
    return if current_user? @user

    flash[:warning] = t "user.require_permission"
    redirect_to root_url
  end
end
