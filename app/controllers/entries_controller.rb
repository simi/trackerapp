class EntriesController < ApplicationController
    def index
        @from = if params[:from]
          Date.strptime(params[:from], '%m/%d/%Y')
        else
          Date.new(Date.today.year, Date.today.month, 1)
        end

        @previous_month = (@from - 1.month).at_beginning_of_month
        @next_month = (@from + 1.month).at_beginning_of_month

        @users = USERS_CONFIG.map do |name, attrs|
          User.new(name, Entry.where(user: name).where('date >= ?', @from).order('date desc'))
        end
    end
end
