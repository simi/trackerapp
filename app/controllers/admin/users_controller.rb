class Admin::UsersController < Admin::ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:admin] == "1"
      @user.admin = true
    end

    if @user.save
      redirect_to admin_path, :notice => "User created."
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_path, :notice => "User updated."
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_path
  end

  def show
    @user = User.find(params[:id])

    @from = if params[:from].present?
              Date.parse(params[:from])
            else
              Date.new(Date.current.year, Date.current.month, 1)
            end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = Entry.for_user(@user).between(@from, @next_month).by_date
    @total = @entries.sum(:minutes)
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
