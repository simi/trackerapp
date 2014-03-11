class Admin::ApplicationController < ApplicationController
  before_filter :require_admin

  private
  def require_admin
    return if current_user.admin?
    flash[:alert] = t('common.must_be_admin')
    redirect_to root_url
  end

end
