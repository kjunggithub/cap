set :stage, :development
set :branch, ENV['BRANCH'] || :develop
set :application, 'kevinjung.ca/'
set :deploy_to, "/home/kjung/websites/#{fetch(:application)}"

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

server '192.210.137.216', user: 'root', roles: [:app]
