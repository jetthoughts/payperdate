source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'pg'

gem 'unicorn'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

#User registrattion
gem 'devise'
gem 'cancan'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'phony_rails'

#Upload photo
gem 'carrierwave'
gem 'mini_magick'
gem 'fog', '~> 1.3.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'knockoutjs-rails', '~> 2.2.1'
gem 'fancybox-rails'
gem 'therubyracer'

#Assets
gem 'sass-rails', '~> 4.0.0'
gem 'sprockets-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'sprockets-rails'

gem 'RedCloth', '~> 4.2.9'
gem 'haml', '~> 4.0.0'
gem 'haml-rails', '~> 0.4'
gem 'haml-contrib', '~> 1.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'handy', github: 'bigbinary/handy'

# Admin Panel
gem 'responders', github: 'plataformatec/responders'
gem 'inherited_resources', github: 'josevalim/inherited_resources'
gem 'ransack', github: 'ernie/ransack', branch: 'rails-4'
gem 'formtastic', github: 'justinfrench/formtastic', branch: 'rails4beta'

gem 'kaminari'
gem 'activeadmin', github: 'gregbell/active_admin', branch: 'rails4'

gem 'jquery-fileupload-rails'

# Background jobs
gem 'redis'
gem 'slim', '>= 1.1.0'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq'

gem 'geocoder'

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'heroku', require: false
end

group :staging do
  gem 'cloudinary'
end

group :staging, :production do
  gem 'rails_12factor'
end

group :test do
  gem 'minitest'
  gem 'simplecov'
  gem 'minitest-reporters', '>= 0.5.0'
  gem 'mocha', require: false
end

group :utils do
  gem 'instapusher'
end
