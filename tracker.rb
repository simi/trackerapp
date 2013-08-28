require 'sinatra'
require 'sinatra/config_file'
require 'date'
require 'letsfreckle'
require_relative 'user'

class Tracker < Sinatra::Base

  register Sinatra::ConfigFile
  config_file 'config/config.yml'

  get '/' do
    @from = if params[:from]
              Date.parse(params[:from])
            else
              Date.new(Date.today.year, Date.today.month, 1)
            end

    @users = User.find_all_from(@from, settings)

    erb :index

  end

end

