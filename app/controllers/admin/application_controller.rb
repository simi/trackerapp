class Admin::ApplicationController < ApplicationController
  before_filter :require_admin

  private
  def require_admin
    return if current_user.admin?
    flash[:error] = "You must be admin to access this section"
    redirect_to root_url
  end

end
