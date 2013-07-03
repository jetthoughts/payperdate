source 'https://rubygems.org'
ruby '2.0.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'pg'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

#User registrtation
gem 'devise', github: 'plataformatec/devise', branch: 'rails4'
gem 'cancan'
gem "recaptcha", :require => "recaptcha/rails"
gem 'omniauth'
gem "omniauth-facebook"
gem "omniauth-twitter"
gem 'phony_rails'
gem 'twilio-ruby'


#Upload photo
gem 'carrierwave'
gem 'mini_magick'
gem 'fog', '~> 1.3.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "twitter-bootstrap-rails"
gem 'knockoutjs-rails', '~> 2.2.1', require: 'knockoutjs-rails'
gem 'fancybox-rails'
gem 'therubyracer'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'handy', github: 'bigbinary/handy'

gem 'will_paginate'

gem 'haml', '~> 4.0.0'
gem 'haml-rails', '~> 0.4'
gem 'haml-contrib', '~> 1.0.0'

gem "jquery-fileupload-rails"
group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'heroku', require: false
end

group :staging do
  gem "cloudinary"
end

group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'sprockets-rails'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'RedCloth', '~> 4.2.9'
  gem 'haml', '~> 4.0.0'
  gem 'haml-rails', '~> 0.4'
  gem 'haml-contrib', '~> 1.0.0'
end

group :development do
  gem 'sass-rails', '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'haml', '~> 4.0.0'
  gem 'haml-rails', '~> 0.4'
  gem 'haml-contrib', '~> 1.0.0'
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
