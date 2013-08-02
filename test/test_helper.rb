ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'

Dir['./test/support/**/*.rb'].sort.each { |f| require f }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include Payperdate::TestHelpers

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

class ActionController::TestCase
  include Devise::TestHelpers
  include Payperdate::TestHelpers
end
