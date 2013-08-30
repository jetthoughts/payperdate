require 'test_helper'

class InvitationTest < ActiveSupport::TestCase

  fixtures :users, :invitations, :block_relationships, :services, :users_dates, :communication_costs

  setup do
    Delayed::Worker.delay_jobs = false
  end

  test 'can_be_countered_by?' do
    invitation = invitations(:martin_mia_pending)
    martin     = users(:martin)
    mia        = users(:mia)
    assert invitation.can_be_countered_by?(mia)
    refute invitation.can_be_countered_by?(martin)
  end

  test 'make counter offer' do
    invitation = invitations(:martin_mia_pending)
    martin     = users(:martin)
    mia        = users(:mia)
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

  test 'need_response_from?' do
    invitation = invitations(:martin_mia_pending)
    martin     = users(:martin)
    mia        = users(:mia)
    assert invitation.need_response_from?(mia)
    refute invitation.need_response_from?(martin)

    invitation.make_counter_offer(999)

    assert invitation.need_response_from?(martin)
    refute invitation.need_response_from?(mia)
  end

  test 'cant invite self' do
    martin     = users(:martin)
    invitation = martin.own_invitations.create(invited_user: martin, amount: 5, message: '?')
    refute invitation.valid?
  end

  test 'cant invite twice' do
    martin     = users(:martin)
    mia        = users(:mia)
    invitation = martin.own_invitations.create(invited_user: mia, amount: 5, message: '?')
    refute invitation.valid?
    back_invitation = mia.own_invitations.create(invited_user: martin, amount: 5, message: '?')
    refute back_invitation.valid?
  end

  test 'create invitation' do
    Invitation.delete_all
    martin = users(:martin)
    mia    = users(:mia)
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
    martin     = users(:martin)
    mia        = users(:mia)

    assert_difference [-> { mia.active_invitations.count },
                       -> { martin.pending_invitations.count }], -1 do
      assert_difference [-> { ActionMailer::Base.deliveries.size },
                         -> { mia.accepted_invitations.count },
                         -> { martin.accepted_invitations.count }], +1 do
        invitation.accept
      end
    end
    notification = ActionMailer::Base.deliveries.last
    assert_equal martin.email, notification.to[0]
    assert_match /accepted/, notification.body.to_s
  end

  test 'reject invitation' do
    invitation = invitations(:martin_mia_pending)
    martin     = users(:martin)
    mia        = users(:mia)

    assert_difference [-> { mia.active_invitations.count },
                       -> { martin.pending_invitations.count }], -1 do
      assert_difference [-> { ActionMailer::Base.deliveries.size },
                         -> { mia.rejected_invitations.count },
                         -> { martin.rejected_invitations.count }], +1 do
        invitation.reject_by_reason('bad')
      end
    end

    assert_equal 'bad', invitation.reject_reason
    notification = ActionMailer::Base.deliveries.last
    assert_equal martin.email, notification.to[0]
    assert_match /rejected/, notification.body.to_s
  end

  test 'cant invite blocked by self' do
    robert     = users(:robert)
    ria        = users(:ria)
    invitation = robert.own_invitations.create(invited_user: ria, amount: 5, message: '?')
    refute invitation.valid?
  end

  test 'cant invite blocker' do
    robert     = users(:robert)
    ria        = users(:ria)
    invitation = ria.own_invitations.create(invited_user: robert, amount: 5, message: '?')
    refute invitation.valid?
  end

  test 'accepted invitation should create users date' do
    invitation = invitations(:martin_mia_pending)
    assert_difference -> { UsersDate.where(owner_id: invitation.user,
                                           recipient_id: invitation.invited_user).count }, +1 do
      invitation.accept!
    end
  end

  test 'invitation amount should be found in communication costs' do
    john     = users(:john)
    mia        = users(:mia)

    invitation = Invitation.new user: john, invited_user: mia, amount: 1
    refute invitation.valid?
    invitation.amount = 50
    assert invitation.valid?
  end

  test 'belongs_to_user?' do
    john     = users(:john)
    mia        = users(:mia)
    martin  = users(:martin)

    invitation = invitations(:martin_mia_pending)
    assert invitation.belongs_to_user?(martin)
    assert invitation.belongs_to_user?(mia)

    refute invitation.belongs_to_user?(john)
  end

  test 'should be acceptable if there is opposite date' do
    invitation = invitations(:lily_john_countered)
    invitation.accept!
    assert invitation.accepted?
  end

  test 'accepting does not create date if there is opposite date' do
    invitation = invitations(:lily_john_countered)
    assert_difference -> { UsersDate.where(owner_id: invitation.user,
                                           recipient_id: invitation.invited_user).count }, 0 do
      invitation.accept!
    end
  end

end
