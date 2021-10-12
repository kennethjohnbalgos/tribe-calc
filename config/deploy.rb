# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

server '144.91.124.223', port: 22, roles: [:web, :app, :db], primary: true
set :application, "tribecalc"
set :repo_url, "git@github.com:kennethjohnbalgos/tribe-calc.git"

set :user, 'kenn'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :keep_releases,   3
set :deploy_to,       "/apps/#{fetch(:application)}"
set :branch,          'main'
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

append :linked_files, "config/master.key", ".env.production"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "public/uploads"

set :rvm_type,          :user  
set :rvm_ruby_version, 'ruby-2.6.3'

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    on roles(:all) do
      within current_path do
        execute :bundle, :exec, 'rails', 'db:seed', 'RAILS_ENV=production'
      end
    end
  end
end