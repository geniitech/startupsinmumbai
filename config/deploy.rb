lock '3.3.3'
require 'capistrano-db-tasks'
set :application, 'startupsinmumbai'
set :repo_url, 'git@github.com:geniitech/startupsinmumbai.git'
set :assets_dir, ["public/assets", "public/system"]
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}
set :default_stage, 'production'
set :deploy_to, '/home/webadmin/sites/startupsinmumbai'
set :deploy_via, :export
set :ssh_options, {
  forward_agent: true
}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
      end
    end
  end

  desc "Symlinks the database.yml"
  task :symlink_db do
    on roles(:web) do
      execute "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    end
  end

  after :updated, :symlink_db
end