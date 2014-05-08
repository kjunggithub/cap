set :stage, :development
set :branch, ENV['BRANCH'] || :develop
set :application, 'cap'
set :deploy_to, "/home/kjung/www/kevinjung.ca/public_html"

server '192.210.137.216', user: 'root', roles: %w{web app db}