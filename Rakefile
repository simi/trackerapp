require "sinatra/activerecord/rake"
require "./tracker"
config_file 'config/config.yml'


task :import do

  Entry.all_original(settings).each do |entry|
    if entry.import?
      puts "saved again"
      entry.save!
    end
  end

end
