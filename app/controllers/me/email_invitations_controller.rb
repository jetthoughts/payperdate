class Me::EmailInvitationsController < ApplicationController

  def new
    @email_invitation = current_user.email_invitations.build
  end

  def create
    @email_invitation = current_user.email_invitations.build email_invitation_attributes
    if @email_invitation.save
      redirect_to root_url, notice: t('.email_invitation_sent')
    else
      render 'new'
    end
  end

  private

  def email_invitation_attributes
    params.require(:email_invitation).permit(:email)
  end

end
