# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, "cap"  # EDIT your app name
set :branch, :master

set :scm, :git
set :repo_url,  "git@github.com:kjunggithub/cap.git" # EDIT your git repository
set :log_level, :debug

set :keep_releases, 5

set :ssh_options, {
  forward_agent: true
}

# set :use_sudo, false

# set :ssh_options, {
#     keys: %w(~/.ssh/id_rsa)
# }

namespace :composer do

    desc "Running Composer Self-Update"
    task :update do
        on roles(:app), in: :sequence, wait: 3 do
            execute :composer, "self-update"
        end
    end

    desc "Running Composer Install"
    task :install do
        on roles(:app), in: :sequence, wait: 3 do
            within release_path  do
                execute :composer, "install"
            end
        end
    end

end

namespace :laravel do

    desc "Setup Laravel folder permissions"
    task :permissions do
        on roles(:app), in: :sequence, wait: 5 do
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
        on roles(:app), in: :sequence, wait: 5 do
            within release_path  do
                execute :php, "artisan migrate"
            end
        end
    end

    desc "Run Laravel Artisan seed task."
    task :seed do
        on roles(:app), in: :sequence, wait: 5 do
            within release_path  do
                execute :php, "artisan db:seed"
            end
        end
    end

    desc "Optimize Laravel Class Loader"
    task :optimize do
        on roles(:app), in: :sequence, wait: 5 do
            within release_path  do
                execute :php, "artisan clear-compiled"
                execute :php, "artisan optimize"
            end
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

end