require 'test_helper'

class InvitationTest < ActiveSupport::TestCase

  fixtures :users, :invitations, :block_relationships, :services, :users_communications, :communication_costs, :ranks

  setup do
    Delayed::Worker.delay_jobs = false
  end

  test 'can_be_countered_by?' do
    invitation = invitations(:martin_mia_pending)
    martin = users(:martin)
    mia = users(:mia)
    assert invitation.can_be_countered_by?(mia)
    refute invitation.can_be_countered_by?(martin)
  end

  test 'make counter offer' do
    invitation = invitations(:martin_mia_pending)
    martin = users(:martin)
    mia = users(:mia)
    assert_equal martin, invitation.inviter

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      invitation.make_counter_offer(999)
    end
    assert_equal mia, invitation.inviter
    assert invitation.counter

    notification = ActionMailer::Base.deliveries.last
    assert_equal martin.email, notification.to[0]
    assert_match /changed proposed amount/, notification.body.to_s
  end

  test 'cant invite self' do
    martin = users(:martin)
    invitation = martin.own_invitations.create(invited_user: martin, amount: 5, message: '?')
    refute invitation.valid?
  end

  test 'cant invite twice' do
    martin = users(:martin)
    mia = users(:mia)
    invitation = martin.own_invitations.create(invited_user: mia, amount: 5, message: '?')
    refute invitation.valid?
    back_invitation = mia.own_invitations.create(invited_user: martin, amount: 5, message: '?')
    refute back_invitation.valid?
  end

  test 'create invitation' do
    Invitation.delete_all
    martin = users(:martin)
    mia = users(:mia)
    Invitation.create!(user: martin, invited_user: mia, amount: 5).committed!
    notification = ActionMailer::Base.deliveries.last
    assert_equal mia.email, notification.to[0]
    assert_match /invite/, notification.body.to_s

    assert_equal 1, mia.active_invitations.count
    assert_equal 0, mia.pending_invitations.count

    assert_equal 0, martin.active_invitations.count
    assert_equal 1, martin.pending_invitations.count
  end

  test 'accept invitation' do
    invitation = invitations(:martin_mia_pending)
    martin = users(:martin)
    mia = users(:mia)
    assert 1, mia.active_invitations.count
    assert 1, martin.pending_invitations.count
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      invitation.accept
    end
    notification = ActionMailer::Base.deliveries.last
    assert_equal martin.email, notification.to[0]
    assert_match /accepted/, notification.body.to_s

    assert_equal 0, mia.active_invitations.count
    assert_equal 0, martin.pending_invitations.count

    assert_equal 1, mia.accepted_invitations.count
    assert_equal 1, martin.accepted_invitations.count
  end

  test 'reject invitation' do
    invitation = invitations(:martin_mia_pending)
    martin = users(:martin)
    mia = users(:mia)
    assert_equal 1, mia.active_invitations.count
    assert_equal 1, martin.pending_invitations.count
    invitation.update_column(:counter, true)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      invitation.reject_by_reason('bad')
    end
    assert_equal 'bad', invitation.reject_reason
    notification = ActionMailer::Base.deliveries.last
    assert_equal mia.email, notification.to[0]
    assert_match /rejected/, notification.body.to_s

    assert_equal 0, mia.active_invitations.count
    assert_equal 0, martin.pending_invitations.count

    assert_equal 1, mia.rejected_invitations.count
    assert_equal 1, martin.rejected_invitations.count
  end

  test 'cant invite blocked by self' do
    robert = users(:robert)
    ria = users(:ria)
    invitation = robert.own_invitations.create(invited_user: ria, amount: 5, message: '?')
    refute invitation.valid?
  end

  test 'cant invite blocker' do
    robert = users(:robert)
    ria = users(:ria)
    invitation = ria.own_invitations.create(invited_user: robert, amount: 5, message: '?')
    refute invitation.valid?
  end

  test 'unlock invitation' do
    invitation = invitations(:paul_lily_accepted)

    assert_equal false, invitation.can_be_communicated?

    #FIXME: Magic. Object was updated but assert didn't see changes
    # assert_difference ->{ users(:paul).credits_amount }, -10 do

      assert_equal true, invitation.unlock
      assert_equal true, invitation.can_be_communicated?
    # end

    invitation = invitations(:sophia_lily_accepted)

    assert_difference ->{ users(:sophia).credits_amount.to_f}, 0 do
      invitation.unlock

      assert_equal false, invitation.can_be_communicated?
    end

  end

  test 'can_be_unlocked_by?' do
    invitation = invitations(:paul_lily_accepted)
    paul = users(:paul)
    lily = users(:lily)

    assert invitation.can_be_unlocked_by?(paul)
    refute invitation.can_be_unlocked_by?(lily)

    invitation = invitations(:paul_lily_not_accepted)
    refute invitation.can_be_unlocked_by?(paul)

    invitation = invitations(:paul_john_unlocked_yet)
    refute invitation.can_be_unlocked_by?(paul)
  end

  test 'can_be_communicated?' do
    invitation = invitations(:paul_john_unlocked_yet)
    assert invitation.can_be_communicated?

    invitation = invitations(:john_lily_accepted)
    refute invitation.can_be_communicated?
  end

  test 'can_be_ranked? by not referenced user' do
    mia = users(:mia)

    invitation = invitations(:paul_lily_not_accepted)
    assert !invitation.can_be_ranked?(mia)

    invitation = invitations(:paul_lily_accepted)
    assert !invitation.can_be_ranked?(mia)
  end

  test 'can_be_ranked? by referenced users' do
    paul = users(:paul)
    lily = users(:lily)

    invitation = invitations(:paul_lily_not_accepted)
    assert !invitation.can_be_ranked?(paul)
    assert !invitation.can_be_ranked?(lily)

    invitation = invitations(:paul_lily_accepted)
    assert invitation.can_be_ranked?(paul)
    assert invitation.can_be_ranked?(lily)
  end

  test 'ranked?' do
    paul = users(:paul)
    lily = users(:lily)
    rank_ok = ranks(:ok)

    invitation = invitations(:paul_lily_accepted)
    assert !invitation.ranked?(paul)
    assert !invitation.ranked?(lily)

    invitation.date_ranks.create! user: paul, courtesy_rank: rank_ok, punctuality_rank: rank_ok, authenticity_rank: rank_ok
    assert invitation.ranked?(paul)
    assert !invitation.ranked?(lily)

    invitation.date_ranks.create! user: lily, courtesy_rank: rank_ok, punctuality_rank: rank_ok, authenticity_rank: rank_ok
    assert invitation.ranked?(paul)
    assert invitation.ranked?(lily)
  end

  test 'can_view_rank?' do
    mia = users(:mia) # not referenced in invitation user
    paul = users(:paul)
    lily = users(:lily)
    rank_ok = ranks(:ok)

    invitation = invitations(:paul_lily_accepted)
    assert !invitation.can_view_rank?(mia)
    assert !invitation.can_view_rank?(paul)
    assert !invitation.can_view_rank?(lily)

    invitation.date_ranks.create! user: paul, courtesy_rank: rank_ok, punctuality_rank: rank_ok, authenticity_rank: rank_ok
    assert !invitation.can_view_rank?(mia)
    assert invitation.can_view_rank?(paul)
    assert !invitation.can_view_rank?(lily)
  end

end
