ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/reporters'
require 'simplecov'
MiniTest::Reporters.use!
SimpleCov.start

Dir['./test/support/**/*.rb'].sort.each { |f| require f }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include Payperdate::TestHelpers

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false

  setup do
    Delayed::Worker.delay_jobs = true
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
  include Payperdate::TestHelpers

  setup do
    Delayed::Worker.delay_jobs = true
  end
end

if ENV['INTEGRATION_TESTS']
  require 'capybara/rails'
  require 'capybara/poltergeist'
  require 'capybara-screenshot/minitest'

  Capybara.current_driver = :poltergeist

  class ActionDispatch::IntegrationTest
    include Capybara::DSL
  end
else
  class ActionDispatch::IntegrationTest
    setup do
      skip 'because this test heavy, to activate run with INTEGRATION_TESTS = true'
    end
  end
end
