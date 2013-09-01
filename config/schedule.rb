job_type :rake,    "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"

every :day, :at => '0:02am' do
  rake "import"
end

every :day, :at => '0am' do
  rake "export"
end
