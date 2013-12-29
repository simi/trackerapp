# Symlinks

desc "Copy configuration files to shared directory"
task :copy_configs_to_shared, :roles => :app do
  run "mkdir -p #{shared_path}/config"
  put(File.read('config/database.yml'), "#{shared_path}/config/database.yml", :mode => 0640)
end

before "deploy:cold", "copy_configs_to_shared"

desc "Setup shared directories"
task :setup_shared_directories, :roles => :app do
  directory_symlinks
  run "mkdir -p #{shared_path}/assets #{shared_path}/ckeditor_assets #{shared_path}/uploads #{shared_path}/backup #{shared_path}/db"
end

after "deploy:setup", "setup_shared_directories"

namespace :deploy do
  desc "Update all the damn symlinks"
  task :update_symlinks, :roles => :app, :except => { :no_release => true } do
    normal_symlinks.map do |path|
      run "rm -rf #{release_path}/#{path} && ln -s #{shared_path}/#{path} #{release_path}/#{path}"
    end

    directory_symlinks.map do |from, to|
      run "rm -rf #{release_path}/#{to} && ln -s #{shared_path}/#{from} #{release_path}/#{to}"
    end
  end
end

after "deploy:update_code", "deploy:update_symlinks"
