source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

gem 'rails-api'

gem 'bcrypt' # For general encryption
gem 'active_model_serializers', '~> 0.9.2' # For JSON generation

# Use sqlite3 as the database for Active Record
gem 'pg'

# Authorization
gem 'pundit'

# Monitoring
gem 'newrelic_rpm', group: :production

# Heroku specific
gem 'rails_12factor', group: :production

# AWS SDK
gem 'aws-sdk', '~> 2'

gem 'awesome_nested_set'

gem 'resque', :require => 'resque/server'

group :production do
  gem 'rails_stdout_logging'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'json_spec'
  gem 'guard-rspec', :git => 'https://github.com/guard/guard-rspec.git'
  gem 'rb-readline', '~> 0.5.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'rubocop'
  gem 'guard-rubocop'
  gem 'database_cleaner'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
