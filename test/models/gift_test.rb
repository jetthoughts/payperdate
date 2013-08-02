require 'test_helper'

class GiftTest < ActiveSupport::TestCase
  fixtures :gift_templates, :users

  def test_create
    gift = Gift.create! gift_template: gift_templates(:kitten),
                        user: users(:john), recipient: users(:mia), comment: nil
    assert_not_predicate gift, :private?
  end

  def test_sending_enabled_gifts
    john = users(:john)
    mia = users(:mia)
    kitten = gift_templates(:kitten)
    assert_difference ->{ Gift.count }, +1 do
      Gift.create user: john, recipient: mia, gift_template: kitten
    end
  end

  def test_sending_disabled_gifts
    john = users(:john)
    mia = users(:mia)
    dark_kitten = gift_templates(:dark_kitten)
    assert_difference ->{ Gift.count }, 0 do
      Gift.create user: john, recipient: mia, gift_template: dark_kitten
    end
  end

  def test_receiving_gifts
    john = users(:john)
    mia = users(:mia)
    kitten = gift_templates(:kitten)
    assert_difference ->{ mia.gifts.count }, +1 do
      Gift.create user: john, recipient: mia, gift_template: kitten
    end
  end

  def test_sending_gifts_to_self
    john = users(:john)
    kitten = gift_templates(:kitten)
    assert_difference ->{ Gift.count }, 0 do
      Gift.create user: john, recipient: john, gift_template: kitten
    end
  end

end
