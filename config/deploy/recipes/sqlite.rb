desc 'Create sqlite database file'
task :create_sqlite_db_file, :roles => :app do
  run "touch #{shared_path}/db/#{rails_env}.sqlite3"
end

after 'setup_shared_directories', 'create_sqlite_db_file'
