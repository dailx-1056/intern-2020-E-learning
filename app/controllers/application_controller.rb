class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.default_locale
    I18n.locale = locale if I18n.available_locales.include?(locale)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "message.user.require_login"
    redirect_to login_url
  end

  def after_sign_in_path_for resource
    if current_user.admin?
      admin_root_url
    else
      stored_location_for(resource) || root_url
    end
  end
end
