ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'

MiniTest::Reporters.use!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers
end
