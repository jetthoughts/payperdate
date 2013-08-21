require 'test_helper'

class WinksControllerTest < ActionController::TestCase
  fixtures :users, :profiles

  setup do
    @wink_template = WinkTemplate.create image: create_tmp_image, name: 'test'
    @martin = users(:martin)
    @mia = users(:mia)
    Delayed::Worker.delay_jobs = false
    sign_in @martin
  end

  test 'deleted user should be labeled as deleted in index' do
    @mia.own_winks.create(wink_template_id: @wink_template.id, recipient_id: @martin.id).committed!
    @mia.delete!
    get :index
    assert_select 'a', 'Mia Mitchell'
    assert_select 'span', 'Deleted'
  end

end
