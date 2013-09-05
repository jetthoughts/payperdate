ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/reporters'
require 'simplecov'
MiniTest::Reporters.use!


SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'

  add_group 'Controllers', '/app/controllers'
  add_group 'Models', '/app/models'
  add_group 'Helpers', '/app/helpers'
  add_group 'Admin', '/app/admin'
  add_group 'Libraries [Devise]', '/lib/devise'
  add_group 'Libraries [Payperdate]', '/lib/payperdate'
end
# somehow this required for library group to work
Dir["lib/**/*.rb"].each {|file| load(file) }
Dir["app/helpers/*.rb"].each {|file| load(file) }
# admin group
Dir["app/admin/*.rb"].each {|file| load(file) }

Dir['./test/support/**/*.rb'].sort.each { |f| require f }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include Payperdate::TestHelpers
  extend Payperdate::TestExtendedHelpers

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false

end

class ActionController::TestCase
  include Devise::TestHelpers

  include Payperdate::TestHelpers
  extend Payperdate::TestExtendedHelpers

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
Timecop.safe_mode = true
