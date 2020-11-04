class SessionsController < ApplicationController
  def new
    session[:return_to] = request.referer
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user &.authenticate(params[:session][:password])
      log_in user
      redirect_to session.delete(:return_to) || root_path
    else
      flash.now[:danger] = t "message.user.login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
