set :application, "sp5"

set :scm, :git
set :scm_command, "/usr/local/git/bin/git"
set :repository, "git://github.com/crcstudio/streetprint.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true

set :user, 'crcstudio'
set :group, 'www'

set :use_sudo, true
set :keep_releases, 3

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

role :app, "192.168.10.10"
role :web, "192.168.10.10"
role :db,  "192.168.10.10", :primary => true

set :deploy_to, "/var/www/#{application}"

depend(:remote, :file, "#{shared_path}/config/database.yml")
depend(:remote, :directory, "#{shared_path}/db/sphinx")

after "deploy:setup", "database:setup"
after "deploy:setup", "sphinx:setup"

after "deploy:update_code", "database:symlink"
after "deploy:update_code", "sphinx:symlink"

# the pid file should be symlinked so after we config
# we can restart
# after "deploy", "db:seed"
after "deploy", "sphinx:config"
after "deploy", "sphinx:stop"
after "deploy", "sphinx:start"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

desc "set proper permissions"
task :set_permissions do
  sudo "chown -R #{user}:#{group} #{deploy_to}"
  sudo "chmod -R g+rw #{deploy_to}"
end

namespace :database do
  desc "Create a database.yml file prompting for the password"
  task :setup do
    mysql_password = Capistrano::CLI.password_prompt("Production MySQL password: ")
    require 'yaml'
    spec = { "production" => {
      "adapter" => "mysql",
      "encoding" => "utf8",
      "database" => "sp5",
      "pool" => 5,
      "username" => "streetprint5",
      "password" => mysql_password,
      "socket" => "/var/mysql/mysql.sock" } }
    run "mkdir -p #{shared_path}/config"
    put(spec.to_yaml, "#{shared_path}/config/database.yml")
  end
  
  desc "Symlink to database.yml file"
  task :symlink do
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc "Seed the db"
  task :seed do
    run "cd #{current_path} && /usr/bin/rake db:seed RAILS_ENV=production"
  end
end

namespace :sphinx do
  task :setup do
    run "mkdir -p #{shared_path}/db/sphinx"
  end

  desc "symlink to sphinx db"
  task :symlink do
    run <<-CMD
      rm -fr #{release_path}/db/sphinx &&
      ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx
    CMD
  end

  [:start, :stop, :restart, :index, :config, :rebuild].each do |t|
    desc "Runs the ts:#{t} task on the server."
    task t do
      run("cd #{current_path} && /usr/bin/rake ts:#{t} RAILS_ENV=production")
    end
  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
