class EmailInvitationMailer < BaseMailer

  def invite_by_email(email_invitation_id)
    @email_invitation = EmailInvitation.find(email_invitation_id)
    @inviter = @email_invitation.user
    mail(to: @email_invitation.email, subject: t('.you_are_invited'))
  end

end
