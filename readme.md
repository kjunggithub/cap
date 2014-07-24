# Deploy Laravel with Capistrano 3
## Set up Capistrano
```shell
echo "gem 'capistrano', '~> 3.2.0'" > Gemfile
bundle install
cap install
```

## Deploy
To deploy the develop branch
* `bundle exec cap development deploy`

To deploy a specific branch
* `BRANCH=branch_name bundle exec cap development deploy`
