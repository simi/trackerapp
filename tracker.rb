require 'sinatra'
require 'sinatra/config_file'
require 'date'
require 'letsfreckle'

config_file 'config.yml'

get '/' do
  @from = if params[:from]
            Date.parse(params[:from])
          else
            Date.new(Date.today.year, Date.today.month, 1)
          end

  @users = settings.users.map do |name, attrs|
    if attrs['tracker'] == 'freckle'
      LetsFreckle.configure do
        account_host attrs['credentials']['host']
        username attrs['credentials']['username']
        token attrs['credentials']['token']
      end
    end

    records = LetsFreckle::Entry.find(:from => @from.to_s)
    {name: name, records: records}
  end

  erb :index

end