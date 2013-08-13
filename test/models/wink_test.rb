require 'test_helper'

class WinkTest < ActiveSupport::TestCase
  fixtures :users, :block_relationships

  setup do
    @wink_template             = WinkTemplate.create image: create_tmp_image, name: 'test'
    @martin = users(:martin)
    @mia = users(:mia)
    @robert = users(:robert)
    @ria = users(:ria)
    Delayed::Worker.delay_jobs = false
  end

  test 'user can create a wink for another user' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      @martin.own_winks.create(wink_template_id: @wink_template.id, recipient_id: @mia.id).committed!
    end
    assert_equal 1, @mia.winks.count
    notification = ActionMailer::Base.deliveries.last
    assert_equal @mia.email, notification.to[0]
    assert_match /wink/, notification.body.to_s
  end

  test 'user can NOT create a wink for self' do
    @martin.own_winks.create(wink_template_id: @wink_template.id, recipient_id: @martin.id)
    assert_equal 0, @martin.winks.count
    assert_equal 0, @martin.own_winks.count
  end

  test 'user can NOT wink to same user twice for day' do
    refute @martin.already_winked?(@mia)
    @martin.own_winks.create(wink_template_id: @wink_template.id, recipient_id: @mia.id)
    assert @martin.already_winked?(@mia)
    @martin.own_winks.create(wink_template_id: @wink_template.id, recipient_id: @mia.id)
    assert_equal 1, @mia.winks.count
    assert_equal 1, @martin.own_winks.count
  end

  test 'user can NOT wink to blocked by himself user' do
    refute @robert.already_winked? @ria
    @robert.own_winks.create wink_template_id: @wink_template.id, recipient_id: @ria.id
    refute @robert.already_winked? @ria
  end

  test 'user can NOT wink to blocker' do
    refute @ria.already_winked? @robert
    @ria.own_winks.create wink_template_id: @wink_template.id, recipient_id: @robert.id
    refute @ria.already_winked? @robert
  end

end
