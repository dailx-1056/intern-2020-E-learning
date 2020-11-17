class UsersController < ApplicationController
  before_action :get_users, only: :index
  before_action :get_user, only: %i(edit update)

  def index
    @users = @users.page(params[:page]).per Settings.per
  end

  def new
    @user = User.new
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
      redirect_to users_url
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

  def get_users
    @users = User.joins(:user_detail)
                 .by_email(params[:email])
                 .by_name(params[:name])
                 .by_role(params[:role])
                 .by_location(params[:location])
                 .by_birthday(params[:start_date], params[:end_date])
  end
end
