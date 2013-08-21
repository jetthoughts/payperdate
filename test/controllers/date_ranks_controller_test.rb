require 'test_helper'

class DateRanksControllerTest < ActionController::TestCase
  fixtures :invitations, :users, :ranks

  def setup
    sign_in users(:john)
  end

  test 'should get new' do
    get :new, invitation_id: invitations(:john_lily_accepted)
    assert_response :success
  end

  test 'create should render new with incomplete data' do
    rank_ok = ranks(:ok)
    post :create, invitation_id: invitations(:john_lily_accepted), date_rank: { courtesy_rank_id: rank_ok }
    assert_response :success
    assert_template :new
  end

  test 'create should redirect to accepted invitations with complete data' do
    rank_ok = ranks(:ok)
    post :create, invitation_id: invitations(:john_lily_accepted), date_rank: { courtesy_rank_id:     rank_ok,
                                                                                punctuality_rank_id:  rank_ok,
                                                                                authenticity_rank_id: rank_ok }
    assert_redirected_to accepted_invitations_path
  end

end
