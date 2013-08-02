class InvitationMailer < BaseMailer
  def invitation_was_rejected(invitation_id)
    @invitation    = Invitation.find(invitation_id)
    @inviter      = @invitation.inviter
    @invited_user = @invitation.recipient
    mail(to: @inviter.email, subject: t('invitations.mailer.your_invitation_was_rejected'))
  end

  def invitation_was_accepted(invitation_id)
    @invitation    = Invitation.find(invitation_id)
    @inviter      = @invitation.inviter
    @invited_user = @invitation.recipient
    mail(to: @inviter.email, subject: t('invitations.mailer.your_invitation_was_accepted'))
  end

  def new_invitation(invitation_id)
    @invitation   = Invitation.find(invitation_id)
    @inviter      = @invitation.inviter
    @invited_user = @invitation.recipient
    mail(to: @invited_user.email, subject: t('invitations.mailer.new_invitation'))
  end

  def counter_invitation(invitation_id)
    @invitation   = Invitation.find(invitation_id)
    @inviter      = @invitation.inviter
    @invited_user = @invitation.recipient
    mail(to: @invited_user.email, subject: t('invitations.mailer.new_counter_invitations'))
  end

end
