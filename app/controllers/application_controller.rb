class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def not_authenticated
    redirect_to login_url, :alert => "Please login to access this app."
  end

  before_filter :set_user_language

  private
  def set_user_language
    I18n.locale = current_user.language if logged_in?
  end

end
