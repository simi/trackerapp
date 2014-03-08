# STAGING-specific deployment configuration
# please put general deployment config in config/deploy/settings.rb

set :user, "#{application}-stg"
set :domain, "#{application}.stg.eballance.cz"
set :is_root_domain, false
set :root_domain, ""
set :branch, "master"

set :deploy_to, "/home/#{user}/web"
set :rails_env, "staging"

set :default_environment, {
  "PATH" => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
}

set :normal_symlinks, ["config/database.yml", "config/secrets.yml", "db/staging.sqlite3"]
