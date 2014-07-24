set :stage, :production
set :branch, ENV['BRANCH'] || :develop
set :application, 'kevinjung.ca/'
set :deploy_to, "/home/kjung/websites/#{fetch(:application)}"

# server '192.210.137.216', user: 'root', roles: %w{web app db}
server '192.210.137.216', user: 'root', roles: [:app]
