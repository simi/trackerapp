class EntriesController < ApplicationController
  before_filter :require_login
  include TimeParser

  def index
    @from = if params[:from]
      Date.strptime(params[:from], '%m/%d/%Y')
    else
      Date.new(Date.today.year, Date.today.month, 1)
    end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = Entry.where(user_id: current_user.id).where('date >= ?', @from).order('date desc')
    @total = @entries.sum(:minutes)

  end

  def new
    @entry = Entry.new
  end

  def create
    @minutes = TimeParser.new(params[:entry][:time_spent]).minutes

    @entry = Entry.new(entry_params)
    @entry.save

    if not @entry.project.users.include?(current_user)
      project_user = ProjectUser.new
      project_user.user_id = current_user.id
      project_user.project_id = @entry.project_id
      project_user.save
    end

    redirect_to entries_path
  end

  private
    def entry_params
      params.require(:entry).permit(:description, :project_id, :date).merge(minutes: @minutes, user_id: current_user.id)
    end
end
