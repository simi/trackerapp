# PRODUCTION-specific deployment configuration
# please put general deployment config in config/deploy/settings.rb

set :user, "#{application}"
set :is_root_domain, false
set :root_domain, ""
set :branch, "master"

set :deploy_to, "/home/#{user}/web"
set :rails_env, "production"

set :default_environment, {
  "PATH" => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
}

set :normal_symlinks, ["config/database.yml", "db/#{rails_env}.sqlite3"]
