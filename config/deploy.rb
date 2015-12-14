

set :application, "demo"
set :repository,  "https://github.com/pradeepachuthan/web_hook_dummy.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }
# default_run_options[:pty] = true
set :user, "ubuntu"
set :group, user
set :runner, user
set :host, "#{user}@52.35.114.16"

role :web, "52.35.114.16"                          # Your HTTP server, Apache/etc
role :app, "52.35.114.16"                          # This may be the same as your `Web` server

set :deploy_to, "/var/www/"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :ssh_options, { 
  forward_agent: true, 
  paranoid: true, 
  keys: "~/.ssh/id_rsa" 
}

namespace :deploy do
  task :restart do
  	p "Executing restarting"
  	run "cd #{deploy_to}/current/ && bundle install"
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf}  -D; fi"
  end
  task :start do
  	p "Executing start"
    run "cd #{deploy_to}/current/ && bundle exec unicorn -c #{unicorn_conf} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end


# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
