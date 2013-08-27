# Bundler tasks
require 'bundler/capistrano'

set :application, "finuslug"
set :repository,  "git@github.com:Agatov/finuslug.git"

set :scm, :git

# do not use sudo
set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }

# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :user, "root"
set :group, user
set :runner, user

set :host, "#{user}@188.120.246.84" # We need to be able to SSH to that box as this user.
role :web, host
role :app, host

set :env, :production

# Where will it be located on a server?
set :deploy_to, "/apps/sinatra/#{application}"
set :unicorn_conf, "#{deploy_to}/shared/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/tmp/pids/unicorn.pid"


#before 'bundle:install', 'deploy:create_folders'

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{env} -D"
  end

  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :create_folders do
    run "mkdir #{current_release}/public"
    run "mkdir #{current_release}/public/images"
    run "mkdir #{current_release}/public/stylesheets"
    run "mkdir #{current_release}/public/javascripts"
  end
end