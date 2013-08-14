ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/reporters'
MiniTest::Reporters.use!

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
else
  class ActionDispatch::IntegrationTest
    setup do
      skip 'because this test heavy, to activate run with INTEGRATION_TESTS = true'
    end
  end
end
