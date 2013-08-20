require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  fixtures :users, :invitations

  setup do
    Delayed::Worker.delay_jobs = false
  end

  test 'deleted users on index should be marked as deleted' do
    users(:martin).delete!
    sign_in(users(:mia))
    get :index
    assert_response :success
    assert_select 'span', 'Deleted'
  end

  test 'deleted users on sent should be marked as deleted' do
    users(:mia).delete!
    sign_in(users(:martin))
    get :sent
    assert_response :success
    assert_select 'span', 'Deleted'
  end
end

