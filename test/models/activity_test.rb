require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  fixtures :users

  def test_create
    Activity.create! user: users(:martin), subject: users(:martin), action: :sign_in
  end
end
