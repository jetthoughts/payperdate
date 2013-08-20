require 'test_helper'

class GiftTest < ActiveSupport::TestCase
  fixtures :gift_templates, :users, :block_relationships

  def test_create
    gift = Gift.create! gift_template: gift_templates(:rose),
                        user: users(:john), recipient: users(:mia), comment: nil
    assert_not_predicate gift, :private?
  end

  def test_sending_enabled_gifts
    john = users(:john)
    mia = users(:mia)
    rose = gift_templates(:rose)
    assert_difference ->{ Gift.count }, +1 do
      Gift.create user: john, recipient: mia, gift_template: rose
    end
  end

  def test_sending_disabled_gifts
    john = users(:john)
    mia = users(:mia)
    camomile = gift_templates(:camomile)
    assert_difference ->{ Gift.count }, 0 do
      Gift.create user: john, recipient: mia, gift_template: camomile
    end
  end

  def test_receiving_gifts
    john = users(:john)
    mia = users(:mia)
    rose = gift_templates(:rose)
    assert_difference ->{ mia.gifts.count }, +1 do
      Gift.create user: john, recipient: mia, gift_template: rose
    end
  end

  def test_sending_gifts_to_self
    john = users(:john)
    rose = gift_templates(:rose)
    assert_difference ->{ Gift.count }, 0 do
      Gift.create user: john, recipient: john, gift_template: rose
    end
  end

  def test_sending_gifts_to_blocker
    ria = users(:ria)
    robert = users(:robert)
    rose = gift_templates(:rose)
    assert_difference ->{ Gift.count }, 0 do
      Gift.create user: ria, recipient: robert, gift_template: rose
    end
  end

  def test_sending_gifts_to_blocked
    ria = users(:ria)
    robert = users(:robert)
    rose = gift_templates(:rose)
    assert_difference ->{ Gift.count }, 1 do
      Gift.create user: robert, recipient: ria, gift_template: rose
    end
  end

  def test_validate_user_credits_amount
    john = users(:john)
    mia = users(:mia)
    roses = gift_templates(:roses)
    assert_difference ->{ Gift.count }, 0 do
      gift = Gift.create user: john, recipient: mia, gift_template: roses
      assert_equal(1,gift.errors.count)
    end
  end

  def test_tracked_send_gift
    john = users(:john)
    mia = users(:mia)
    rose = gift_templates(:rose)
    assert_difference ->{ john.credits_amount }, -(rose.cost) do
      Gift.create user: john, recipient: mia, gift_template: rose
    end
    transaction = Transaction.last
    assert_equal(-(rose.cost), transaction.amount)
    assert_equal("send_gift", transaction.key)
  end

end
