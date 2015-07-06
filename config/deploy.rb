set :scm, :git
set :application, "blog"
set :repo_url,  "git@gitlab.com:kjunggitlab/blog.git"
set :log_level, :debug
set :keep_releases, 5
set :ssh_options, { forward_agent: true }

set :linked_files, %w{.env}
set :linked_dirs, %w{app/storage}

# git daemon --base-path=/Users/kjung/Sites --export-all
# set :repo_url,  "git://WAN IP:/#{fetch(:repo_name)}" # git daemon port: 9418

# set :use_sudo, false
# set :ssh_options, {keys: %w(~/.ssh/id_rsa)}

# tasks
namespace :composer do

    desc "Running Composer Self-Update"
    task :selfupdate do
        on roles(:app), in: :sequence, wait: 2 do
            execute :composer, "self-update"
        end
    end

    desc "Running Composer Install"
    task :install do
        on roles(:app), in: :sequence, wait: 2 do
            within release_path  do
                execute :composer, "install"
            end
        end
    end

end

namespace :laravel do

    desc "Setup Laravel folder permissions"
    task :permissions do
        on roles(:app), in: :sequence, wait: 2 do
            within release_path  do
                execute :chmod, "u+x artisan"
                execute :chmod, "-R 777 app/storage"
            end
        end
    end

    desc "Run Laravel Artisan migrate task."
    task :migrate do
        on roles(:app), in: :sequence, wait: 2 do
            within release_path  do
                execute :php, "artisan migrate"
            end
        end
    end

    desc "Set up Laravel storage folders."
    task :create_storage do
    required_directories = [
          "#{shared_path}/app/storage/cache",
          "#{shared_path}/app/storage/logs",
          "#{shared_path}/app/storage/meta",
          "#{shared_path}/app/storage/sessions",
          "#{shared_path}/app/storage/views",
      ]
      on roles(:web) do
        required_directories.each do |directory|
          execute "if test ! -d #{directory}; then mkdir -m 777 -p #{directory} 1>&2; true; fi"
        end
      end
    end

    desc "Run Laravel Artisan seed task."
    task :seed do
        on roles(:app), in: :sequence, wait: 2 do
            within release_path  do
                execute :php, "artisan db:seed"
            end
        end
    end

    desc "Optimize Laravel Class Loader"
    task :optimize do
        on roles(:app), in: :sequence, wait: 2 do
            within release_path  do
                execute :php, "artisan clear-compiled"
                execute :php, "artisan optimize"
            end
        end
    end

end

namespace :environment do
    desc "Restart webserver and php after deploying."
    task :restart do
      on roles(:web) do
        # execute "sudo service php5-fpm restart"
        execute "sudo service apache2 restart"
      end
    end
end

namespace :deploy do
    after :published, "composer:selfupdate"
    after :published, "composer:install"
    after :published, "laravel:create_storage"
    after :published, "laravel:permissions"
    after :published, "laravel:optimize"
    after :published, "environment:restart"
end