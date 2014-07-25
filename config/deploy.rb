# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, "Cap!"  # EDIT your app name

set :scm, :git
set :repo_name, "cap"
set :repo_url,  "git@github.com:kjunggithub/#{fetch(:repo_name)}.git" # EDIT your git repository
# set :repo_url,  "git://WAN IP:/#{fetch(:repo_name)}" # git daemon port: 9418

set :log_level, :debug

set :keep_releases, 5

# set :linked_files, %w{readme.md setup.md}
# set :linked_dirs, %w{web/app/uploads}

set :ssh_options, {
  forward_agent: true
}

# set :use_sudo, false

# set :ssh_options, {
#     keys: %w(~/.ssh/id_rsa)
# }

# tasks
namespace :composer do

    desc "Running Composer Self-Update"
    task :update do
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
                # execute :chmod, "-R 777 app/storage/cache"
                # execute :chmod, "-R 777 app/storage/logs"
                # execute :chmod, "-R 777 app/storage/meta"
                # execute :chmod, "-R 777 app/storage/sessions"
                # execute :chmod, "-R 777 app/storage/views"
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

desc "Excecute shell commands"

    task :shell do
        on roles(:app), in: :sequence, wait: 2 do
            execute "mkdir -p #{shared_path}/logs/"
        end
    end

end

namespace :deploy do

    after :published, "composer:update"
    after :published, "composer:install"
    after :published, "laravel:permissions"
    after :published, "laravel:optimize"
    # after :published, "laravel:migrate"
    # after :published, "laravel:seed"
    # after :published, "environment:shell"

end