require 'test_helper'

class GiftTest < ActiveSupport::TestCase
  def test_create
    gift = Gift.create! image: create_tmp_image
    assert_predicate gift, :enabled?
  end

  def test_disable
    gift = Gift.create! image: create_tmp_image
    gift.disable
    assert_predicate gift, :disabled?
  end

  def test_enable
    gift = Gift.create! image: create_tmp_image
    gift.enable
    assert_predicate gift, :enabled?
  end
end
