class Admin::AdminController < Admin::ApplicationController

  def index
    @projects = Project.all
    @users = User.all
  end

end
