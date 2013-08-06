module InvitationsMethods
  def active_invitations
    u_id = self.id
    Invitation.where { (user_id.eq(u_id) & counter.eq(true)) | (invited_user_id.eq(u_id) & counter.eq(false)) }.pending
  end

  def pending_invitations
    u_id = self.id
    Invitation.where { (user_id.eq(u_id) & counter.eq(false)) | (invited_user_id.eq(u_id) & counter.eq(true)) }.pending
  end

  def accepted_invitations
    u_id = self.id
    Invitation.where { user_id.eq(u_id) | invited_user_id.eq(u_id) }.accepted
  end

  def rejected_invitations
    u_id = self.id
    Invitation.where { user_id.eq(u_id) | invited_user_id.eq(u_id) }.rejected
  end

  def can_invite?(user)
    !operate_with_himself?(user) && !already_invited?(user)
  end

  def already_invited?(invited_user)
    self.pending_invitations.where(invited_user_id: invited_user.id).any? || invited_user.pending_invitations.where(invited_user_id: self.id).any?
  end

end