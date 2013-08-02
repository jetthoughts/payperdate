require 'test_helper'

class GiftTemplateTest < ActiveSupport::TestCase
  def test_create
    gift_template = GiftTemplate.create! image: create_tmp_image
    assert_predicate gift_template, :enabled?
  end

  def test_disable
    gift_template = GiftTemplate.create! image: create_tmp_image
    gift_template.disable
    assert_predicate gift_template, :disabled?
  end

  def test_enable
    gift_template = GiftTemplate.create! image: create_tmp_image, state: :disabled
    gift_template.enable
    assert_predicate gift_template, :enabled?
  end
end
