require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  fixtures :users, :invitations

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
end
