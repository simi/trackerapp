class Admin::ProjectsController < Admin::ApplicationController

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project_form.submit
      redirect_to admin_path, :notice => "Project created."
    else
      render :index
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    #@user_ids = project_params[:user_ids].map(&:present)
    
    if @project.update(project_params)# && @project.user_ids = @user_ids
      redirect_to admin_path, :notice => "Project updated."
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to admin_path, :notice => "Project destroyed."
  end

  def show
    @project = Project.find(params[:id])

    @from = if params[:from].present?
              Date.parse(params[:from])
            else
              Date.new(Date.current.year, Date.current.month, 1)
            end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = Entry.for_project(@project).between(@from, @next_month).by_date
    @total = @entries.sum(:minutes)
  end

  private

  def project_params
    params.require(:project).permit!
  end

end
