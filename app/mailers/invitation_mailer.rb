class InvitationMailer < BaseMailer
  def invitation_was_rejected(invitation_id)
    @invitation    = Invitation.find(invitation_id)
    @inviter      = @invitation.inviter
    return unless @inviter.settings.notify_invitation_responded?
    @invited_user = @invitation.recipient
    mail(to: @inviter.email, subject: t('invitations.mailer.your_invitation_was_rejected'))
  end

  def invitation_was_accepted(invitation_id)
    @invitation    = Invitation.find(invitation_id)
    @inviter      = @invitation.inviter
    return unless @inviter.settings.notify_invitation_responded?
    @invited_user = @invitation.recipient
    mail(to: @inviter.email, subject: t('invitations.mailer.your_invitation_was_accepted'))
  end

  def new_invitation(invitation_id)
    @invitation   = Invitation.find(invitation_id)
    @invited_user = @invitation.recipient
    return unless @invited_user.settings.notify_invitation_received?
    @inviter = @invitation.inviter
    mail(to: @invited_user.email, subject: t('invitations.mailer.new_invitation'))
  end

  def counter_invitation(invitation_id)
    @invitation   = Invitation.find(invitation_id)
    @invited_user = @invitation.recipient
    return unless @invited_user.settings.notify_invitation_responded?
    @inviter = @invitation.inviter
    mail(to: @invited_user.email, subject: t('invitations.mailer.your_invitation_was_countered'))
  end

end
