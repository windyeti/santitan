# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "santitan"
set :repo_url, "git@github.com:windyeti/santitan.git"
set :deploy_to, "/var/www/santitan"
append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public", "storage"
set :format, :pretty
set :log_level, :info

after 'deploy:publishing', 'unicorn:restart'
