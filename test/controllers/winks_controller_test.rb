require 'test_helper'

class WinksControllerTest < ActionController::TestCase
  fixtures :users, :profiles

  setup do
    @wink_template = WinkTemplate.create image: create_tmp_image, name: 'test'
    @martin = users(:martin)
    @mia = users(:mia)
    sign_in @martin
  end

  def test_create
    assert_difference -> { @martin.own_winks.count }, +1 do

      post :create, user_id: @mia, wink: { wink_template_id: @wink_template }

      assert_response :success
      json = JSON.parse(response.body)
      assert json['success']
    end
  end

  def test_create_on_error
    @martin.own_winks.destroy_all
    assert_difference -> { @martin.own_winks.count }, 0 do

      post :create, user_id: @mia, wink: { wink_template_id: 22 }

      assert_response :success
      json = JSON.parse(response.body)
      refute json['success']
    end
  end

  test 'deleted user should be labeled as deleted in index' do
    @mia.own_winks.create(wink_template_id: @wink_template.id, recipient_id: @martin.id).committed!
    @mia.delete!
    get :index
    assert_select 'a', 'Mia Mitchell'
    assert_select 'span', 'Deleted'
  end

end
