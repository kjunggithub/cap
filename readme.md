# Deploy Laravel 5.1 with Capistrano 3.4
## Set up Capistrano
```shell
echo "gem 'capistrano', '~> 3.4.0'" > Gemfile
bundle install
bundle update
cap install
```
After Capistrano is all set up, configure `/config/deploy.rb` and `/config/deploy/production.rb` using the files in this repository as an example.

## Deploy server tips
* Create a user to deploy with
* Set apache vhost document root to `/current/`
* Upload `.env` file to `/shared/` and use `:linked_files` and `:linked_dirs` to symlink the app files
* Don't forget to run `php artisan key:generate`

## Deploy Instructions
To deploy the develop branch
* `bundle exec cap development deploy`

To deploy a specific branch
* `BRANCH=branch_name bundle exec cap development deploy`