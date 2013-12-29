set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, "eballance-tracker"
set :domain, "tracker.eballance.cz"
