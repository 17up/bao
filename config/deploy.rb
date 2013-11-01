# coding: utf-8
require "rvm/capistrano"
require "bundler/capistrano"

#set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"
default_run_options[:pty] = true
#set :rvm_ruby_string, 'ruby-2.0.0-p195'
set :rvm_type, :user

set :application, "mp"
set :repository,  "http://libiao:kkxlkkxllb225@42.120.32.202:82/git/mp.git"
set :branch, "master"
set :scm, :git

set :keep_releases, 3   # 留下多少个版本的源代码
set :user, "hduser"
set :password, "hadoop"
set :deploy_to, "/data/app/#{application}/"
set :runner, "ruby"
set :use_sudo,  false
set :deploy_via, :remote_cache

role :web, "192.168.88.104"                          # Your HTTP server, Apache/etc
role :app, "192.168.88.104"                          # This may be the same as your `Web` server
role :db,  "192.168.88.104", :primary => true # This is where Rails migrations will run

set :rails_env, :production
# unicorn.rb 路径
set :unicorn_path, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  end

  task :stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true }  do
    run "touch #{current_path}/tmp/restart.txt;kill -USR2 `cat #{unicorn_pid}`"
  end
end


task :link_shared_files, :roles => :web do
  run "ln -nfs #{deploy_to}shared/*.yml #{release_path}/config/"
  run "ln -nfs #{deploy_to}shared/unicorn.rb #{release_path}/config/"
  run "ln -nfs #{deploy_to}shared/production.rb #{release_path}/config/environments/"
end

# task :compile_assets, :roles => :web do
#   run "cd #{release_path} && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:clean assets:precompile"
# end

#task :sync_assets_to_cdn, :roles => :web do
#  run "cd #{deploy_to}current/; RAILS_ENV=production bundle exec rake assets:cdn"
#end


after "deploy:update_code", :link_shared_files#, :compile_assets#, :sync_assets_to_cdn, :mongoid_migrate_database
after "deploy:restart", "deploy:cleanup"
