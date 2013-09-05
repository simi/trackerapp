require "sinatra/activerecord/rake"
require "./tracker"
require "httparty"
config_file 'config/config.yml'

task :import do

  Entry.all_original(settings).each do |entry|
    if entry.import?
      entry.save!
    end
  end

end

task :export do

  Entry.where(exported: false).each do |entry|
    user = settings.users.detect{|name, attrs| name == entry.user }
    apikey = user[1]['minutedock_apikey']
    next if apikey.blank?
    url = "https://minutedock.com/api/v1/entries.json?api_key=#{apikey}"
    body = {
      entry: {
        duration: entry.minutes * 60,
        description: entry.description,
        logged_at: entry.date.to_time
      }
    }
    response = HTTParty.post(url, body: body)
    entry.update_column(:exported, true) if response.code == 200
  end

end

task :fix do
  Entry.where(user: 'josef').where("date >= ?", Date.new(2013, 9, 1)).destroy_all
end
