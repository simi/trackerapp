class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.where("username like ?", "%#{params[:q]}%")

    @user ||= User.new

    respond_to do |format|
      format.html
      format.json { render :json => @users.map { |user| {:id => user.id, :name => user.username} }}
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:admin] == "1"
      @user.admin = true
    end

    if @user.save
      redirect_to admin_users_path, :notice => "User created."
    else
      index
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, :notice => "User updated."
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id])

    @from = if params[:from]
      Date.strptime(params[:from], '%d/%m/%Y')
    else
      Date.new(Date.today.year, Date.today.month, 1)
    end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = @user.entries.where('date >= ?', @from).where('date < ?', @next_month).order('date desc')

    @total = @entries.sum(:minutes)
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def require_admin
    unless current_user.admin?
      flash[:error] = "You must be admin to access this section"
      redirect_to root_url
    end
  end
end
