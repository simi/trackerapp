class EntriesController < ApplicationController
  before_filter :require_login

  def index
    @from = if params[:from].present?
              Date.parse(params[:from])
            else
              Date.new(Date.current.year, Date.current.month, 1)
            end

    @previous_month = (@from - 1.month).at_beginning_of_month
    @next_month = (@from + 1.month).at_beginning_of_month

    @entries = Entry.for_user(current_user).between(@from, @next_month).by_date
    @total = @entries.sum(:minutes)

    @entry_form ||= EntryForm.new
  end

  def new
    @entry_form = EntryForm.new
  end

  def create
    @entry_form = EntryForm.new(entry_form_params)
    if @entry_form.submit
      redirect_to entries_path, :notice => t('entries.entry_created')
    else
      index
      render :index
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    redirect_to root_path, :notice => t('entries.entry_deleted')
  end

  private
  def entry_form_params
    params.require(:entry_form).
      permit(:description, :date, :time_spent, :project_id).
      merge(user_id: current_user.id)
  end

end
