class ProjectsController < ApplicationController
  before_action :require_admin

  def new
    @project = Project.new
  end

  def index
    @projects = Project.all
    @users = User.all

    @project ||= Project.new
  end

  def show
    @project = Project.find(params[:id])

    @from = if params[:from]
      Date.strptime(params[:from], '%d/%m/%Y')
    else
      Date.new(Date.today.year, Date.today.month, 1)
    end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = @project.entries.where('date >= ?', @from).where('date < ?', @next_month).order('date desc')

    @total = @entries.sum(:minutes)
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to projects_path, :notice => "Project updated."
    else
      render 'edit'
    end
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to projects_path, :notice => "Project created."
    else
      index
      render :index
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :user_tokens)
  end

  def require_admin
    unless current_user.admin?
      flash[:error] = "You must be admin to access this section"
      redirect_to root_url
    end
  end
end

