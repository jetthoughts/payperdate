require 'test_helper'

class UsersDateTest < ActiveSupport::TestCase
  fixtures :users, :users_dates, :ranks, :invitations, :communication_costs

  def test_create
    UsersDate.create! owner: users(:paul), recipient: users(:sophia)
  end

  def test_should_not_create_if_exists
    # locked_date_paul_john exists
    users_date = UsersDate.create owner: users(:john), recipient: users(:paul)
    assert users_date.errors.any?
    users_date = UsersDate.create owner: users(:paul), recipient: users(:john)
    refute users_date.valid?
  end

  def test_belongs_to?
    users_date = users_dates(:unlocked_date_sophia_lily)
    assert users_date.belongs_to?(users(:sophia))
    assert users_date.belongs_to?(users(:lily))
    refute users_date.belongs_to?(users(:paul))
  end

  def test_scope_by
    lily = users(:lily)
    users_dates = UsersDate.by(lily)
    users_dates.each do |users_date|
      assert users_date.belongs_to?(lily)
    end
  end

  def test_scope_locked
    users_dates = UsersDate.locked
    users_dates.each do |users_date|
      refute users_date.unlocked?
    end
  end

  def test_scope_unlocked
    users_dates = UsersDate.unlocked
    users_dates.each do |users_date|
      assert users_date.unlocked?
    end
  end

  def test_can_be_ranked_by_not_referenced_user
    mia = users(:mia)

    users_date = users_dates(:locked_date_john_lily)
    assert !users_date.can_be_ranked?(mia)

    #users_date.unlock!
    #assert !users_date.can_be_ranked?(mia)
  end

  def test_can_be_ranked_by_not_ferenced_user
    paul = users(:paul)
    lily = users(:lily)

    users_date = users_dates(:locked_date_john_lily)
    refute users_date.can_be_ranked?(paul)
    refute users_date.can_be_ranked?(lily)

    #users_date.unlock!
    #assert invitation.can_be_ranked?(paul)
    #assert invitation.can_be_ranked?(lily)
  end

  def test_ranked?
    sophia = users(:sophia)
    lily = users(:lily)
    rank_ok = ranks(:ok)

    users_date = users_dates(:unlocked_date_sophia_lily)
    assert !users_date.ranked?(sophia)
    assert !users_date.ranked?(lily)

    users_date.date_ranks.create! user: sophia, courtesy_rank: rank_ok, punctuality_rank: rank_ok, authenticity_rank: rank_ok
    assert users_date.ranked?(sophia)
    assert !users_date.ranked?(lily)

    users_date.date_ranks.create! user: lily, courtesy_rank: rank_ok, punctuality_rank: rank_ok, authenticity_rank: rank_ok
    assert users_date.ranked?(sophia)
    assert users_date.ranked?(lily)
  end

  def test_can_view_rank?
    mia = users(:mia) # not referenced in invitation user
    sophia = users(:sophia)
    lily = users(:lily)
    rank_ok = ranks(:ok)

    users_date = users_dates(:unlocked_date_sophia_lily)
    assert !users_date.can_view_rank?(mia)
    assert !users_date.can_view_rank?(sophia)
    assert !users_date.can_view_rank?(lily)

    users_date.date_ranks.create! user: sophia, courtesy_rank: rank_ok, punctuality_rank: rank_ok, authenticity_rank: rank_ok
    assert !users_date.can_view_rank?(mia)
    assert users_date.can_view_rank?(sophia)
    assert !users_date.can_view_rank?(lily)
  end

  def test_can_be_unlocked_by?
    john = users(:john)
    lily = users(:lily)
    sophia = users(:sophia)

    users_date = users_dates(:locked_date_john_lily)
    assert users_date.can_be_unlocked_by?(john)
    refute users_date.can_be_unlocked_by?(lily)

    users_date = users_dates(:unlocked_date_sophia_lily)
    refute users_date.can_be_unlocked_by?(sophia)
    refute users_date.can_be_unlocked_by?(lily)
  end

  def test_can_be_communicated?
    users_date = users_dates(:locked_date_paul_john)

    refute users_date.can_be_communicated?(users_date.owner, users_date.recipient)
    assert users_date.can_be_communicated?(users_date.recipient, users_date.owner)

    users_date = users_dates(:unlocked_date_sophia_lily)

    assert users_date.can_be_communicated?(users_date.owner, users_date.recipient)
    assert users_date.can_be_communicated?(users_date.recipient, users_date.owner)
  end

  def test_unlock_invitation
    users_date = users_dates(:locked_date_paul_john)
    refute users_date.can_be_communicated?(users_date.owner, users_date.recipient)

    # FIXME: Magic. Object was updated but assert didn't see changes
    #assert_difference ->{ users(:paul).credits_amount }, -10 do
      users_date.unlock
      assert users_date.can_be_communicated?(users_date.owner, users_date.recipient)
    #end

    users_date = users_dates(:locked_date_john_lily)
    refute users_date.can_be_communicated?(users_date.owner, users_date.recipient)

    assert_difference ->{ users(:john).credits_amount.to_f }, 0 do
      users_date.unlock
      refute users_date.can_be_communicated?(users_date.owner, users_date.recipient)
    end
  end

end
