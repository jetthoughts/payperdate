require 'test_helper'

class EmailInvitationTest < ActiveSupport::TestCase
  fixtures :users, :email_invitations

  test 'create' do
    EmailInvitation.create!(user: users(:mia), email: 'example@example.com')
  end

  test 'should send email on create' do
    Delayed::Worker.delay_jobs = false

    assert_difference -> { ActionMailer::Base.deliveries.size }, +1 do
      email_invitation = EmailInvitation.create!(user: users(:mia), email: 'example@example.com')
      assert_equal email_invitation.email, ActionMailer::Base.deliveries.last.to[0]
    end

    Delayed::Worker.delay_jobs = true
  end

  test 'should be invalid if user blank' do
    email_invitation = EmailInvitation.create(email: 'example@example.com')
    refute email_invitation.valid?
  end

  test 'should be invalid if email blank' do
    email_invitation = EmailInvitation.create(user: users(:mia))
    refute email_invitation.valid?
  end

  test 'should be invalid if user already registered blank' do
    email_invitation = EmailInvitation.create(user: users(:mia), email: users(:martin).email)
    refute email_invitation.valid?
  end

end
