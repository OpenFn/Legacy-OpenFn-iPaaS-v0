source 'https://rubygems.org'

ruby '2.1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.0'

gem 'pry'
gem 'pry-rails'
gem 'colored'

# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'bootstrap-sass', '~> 3.1.1'

gem "resque", '~> 1.25'
gem 'resque-web', require: 'resque_web'

gem "newrelic_rpm"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem "active_model_serializers"

gem 'rails_12factor', group: :production

gem 'faraday', '~> 0.8.6'

gem 'state_machine'

gem 'hashie'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# => Funci Gem to interact with ODK aggregate
gem 'odk_aggregate', :git => 'https://github.com/func-i/odk_aggregate.git', branch: 'feature/9-repeat-block-form-fields'
#gem 'odk_aggregate', path: "~/Documents/funci/odk_aggregate"

# => Gem for SalesForce
gem 'restforce', git: 'https://github.com/icambron/restforce.git'

# => Application ENV vars
gem 'figaro'

# => Pagination
gem 'kaminari'

# Fast Rails loading
gem 'spring'

# => Clone AR objects
gem 'deep_cloneable', '~> 2.0.0'

# => Using jquery UI for draggable
gem 'jquery-ui-rails'

gem 'angularjs-rails', '1.2.16'
gem 'angular-ui-bootstrap-rails'
gem 'angular_ui_tree_rails'
gem 'ng-rails-csrf'

gem 'sorcery'

# XML
gem 'nokogiri'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
#
group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  # gem 'rb-fsevent' if `uname` =~ /Darwin/
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

