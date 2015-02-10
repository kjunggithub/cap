# Deploy Laravel 5 with Capistrano 3

## Set up Capistrano
```shell
echo "gem 'capistrano', '~> 3.3.0'" > Gemfile
bundle install
bundle update
cap install
```
After Capistrano is all set up, configure `/config/deploy.rb` and `/config/deploy/development.rb`.

## Deploy server tips
* Create a user to deploy with
* Set apache vhost document root to `/current/`
* Upload a file to `/shared/` and use `:linked_files` and `:linked_dirs` to symlink the app files

## Deploy Instructions
To deploy the develop branch
* `bundle exec cap development deploy`

To deploy a specific branch
* `BRANCH=branch_name bundle exec cap development deploy`