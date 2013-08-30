require 'test_helper'

class Me::DateRanksControllerTest < ActionController::TestCase
  fixtures :users_dates, :users, :ranks

  def setup
    sign_in users(:sophia)
  end

  test 'should get new' do
    get :new, users_date_id: users_dates(:unlocked_date_sophia_lily)
    assert_response :success
  end

  test 'create should render new with incomplete data' do
    rank_ok = ranks(:ok)
    post :create, users_date_id: users_dates(:unlocked_date_sophia_lily), date_rank: { courtesy_rank_id: rank_ok }
    assert_response :success
    assert_template :new
  end

  test 'create should redirect to accepted invitations with complete data' do
    rank_ok = ranks(:ok)
    post :create, users_date_id: users_dates(:unlocked_date_sophia_lily), date_rank: { courtesy_rank_id:     rank_ok,
                                                                                       punctuality_rank_id:  rank_ok,
                                                                                       authenticity_rank_id: rank_ok }
    assert_redirected_to users_dates_path
  end

end
