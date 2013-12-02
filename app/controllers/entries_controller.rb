class EntriesController < ApplicationController
  before_filter :require_login
 
  def index
    @from = if params[:from]
      Date.strptime(params[:from], '%m/%d/%Y')
    else
      Date.new(Date.today.year, Date.today.month, 1)
    end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = Entry.where(username: current_user.username).where('date >= ?', @from).order('date desc')
    @total = @entries.sum(:minutes)

  end

  def new
    @entry = Entry.new
  end

  def create
    # 1:30, 1.5, 90, 1h
    time_spent = params[:entry][:time_spent]
    if time_spent.include? ":"
      hours, mins = time_spent.split(":")
      @minutes = hours.to_i * 60 + mins.to_i
    elsif time_spent.include? "."
      mins = time_spent.to_f * 60
      @minutes = mins.to_i
    elsif time_spent.include? "h"
      mins = time_spent.to_f * 60
      @minutes = mins.to_i 
    else
      @minutes = time_spent.to_i
    end

    @entry = Entry.new(entry_params)
    @entry.save

    if not ProjectUser.find_by(:user_id => current_user.id, :project_id => @entry.project_id)
      project_user = ProjectUser.new
      project_user.user_id = current_user.id
      project_user.project_id = @entry.project_id
      project_user.save
    end

    redirect_to entries_path 
  end

  private
    def entry_params
      params.require(:entry).permit(:description, :project_id, :date).merge(minutes: @minutes, user_id: current_user.id, username: current_user.username)
    end
end
