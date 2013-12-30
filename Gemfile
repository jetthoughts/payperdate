source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'pg'
gem 'squeel'
gem 'state_machine'
gem 'activemerchant'

gem 'unicorn'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# User registrattion
gem 'devise', '>= 3.0.2'
gem 'cancan'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'phony_rails'
gem 'money-rails'

# Upload photo
gem 'carrierwave'
gem 'mini_magick'
gem 'fog', '~>1.14'

# Assets

## Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'jquery-fileupload-rails'
gem 'knockoutjs-rails', '~> 2.2.1'
gem 'fancybox-rails'
gem 'therubyracer'

gem 'coffee-rails', '~> 4.0.0'

gem 'sass-rails', '~> 4.0.0'
gem 'sprockets-rails'
gem 'uglifier', '>= 1.3.0'

# View
gem 'RedCloth', '~> 4.2.9'
gem 'haml', '~> 4.0.0'
gem 'haml-rails', '~> 0.4'
gem 'haml-contrib', '~> 1.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'handy', github: 'bigbinary/handy'

gem 'ransack'

gem 'activeadmin', github: 'gregbell/active_admin'
gem 'draper', '>= 1.0.0'

#FIXME: @XsErG please update to jetthoughts/mandrill-api
gem 'mandrill-api', github: 'XsErG/mandrill-api', require: 'mandrill'

gem 'obscenity' # profanity filter, used only to help approver

# Background jobs
gem 'delayed_job_active_record', '>= 4.0.0.beta1'
gem 'delayed_job_web'

# External API
gem 'geocoder'
gem 'nude'
gem 'face'
gem 'foursquare2'
group :staging, :production do
  gem 'airbrake'
end

group :development, :test do
  gem 'capybara'
  gem 'simplecov', github: 'colszowka/simplecov', branch: 'v0.8.0.pre', require: false
  gem 'poltergeist'
  gem 'capybara-screenshot'
  gem 'awesome_print'
  gem 'timecop'
end

group :development do
  gem 'quiet_assets'
  gem 'better_errors', require: false
  gem 'binding_of_caller', require: false
  gem 'pry-rails'
  #FIXME: @XsErG please update to jetthoughts/push2heroku
  gem 'push2heroku', github: 'XsErG/push2heroku'
end

group :staging do
  gem 'cloudinary'
end

group :staging, :production do
  gem 'rails_12factor'
end

group :test do
  gem 'minitest'
  gem 'simplecov', github: 'colszowka/simplecov', branch: 'v0.8.0.pre'
  gem 'minitest-reporters', '>= 0.5.0'
  gem 'mocha', require: false
  gem 'zeus'
end

group :utils do
  gem 'instapusher'
end
