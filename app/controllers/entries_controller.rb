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

    @entries = Entry.where(user: current_user.username).where('date >= ?', @from).order('date desc')
    @total = @entries.sum(:minutes)
  end
end
