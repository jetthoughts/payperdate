require 'test_helper'

class GiftsControllerTest < ActionController::TestCase

  fixtures :users, :gift_templates, :gifts

  setup do
    @current_user = users(:john)
    sign_in @current_user

    @mia = users(:mia)
  end

  test 'new should response success' do
    get :new, user_id: @mia
    assert_response :success
  end

  test 'create should redirect to user page on success' do
    put :create, user_id: @mia, gift: { gift_template_id: gift_templates(:rose),
                                        comment:          'some comment',
                                        private:          true }
    assert_redirected_to user_profile_path(@mia)
    assert_match /was sent/, flash[:notice]
  end

  test 'create render new on errors' do
    put :create, user_id: @mia, gift: { gift_template_id: gift_templates(:camomile),
                                        comment:          'some comment',
                                        private:          true }
    assert_response :success
    assert_template :new
    assert assigns(:gift).errors.any?
  end

end
