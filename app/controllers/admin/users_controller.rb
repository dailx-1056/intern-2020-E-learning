class Admin::UsersController < Admin::BaseController
  before_action :get_user, only: %i(edit update)

  load_and_authorize_resource

  def index
    @q = User.includes(:user_detail).ransack params[:q]
    @users = @q.result.page(params[:page]).per Settings.per
  end

  def edit
    @user.build_user_detail if @user.user_detail.blank?
  end

  def update
    if @user.update user_params
      flash[:success] = t "message.user.update_success"
      redirect_to admin_users_path
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
end
