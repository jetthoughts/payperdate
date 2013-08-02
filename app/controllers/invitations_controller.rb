class InvitationsController < BaseController

  before_action :find_invitation, only: [:accept, :reject, :counter, :destroy]

  def create
    invitation = current_user.own_invitations.build(invitation_params)
    result     = if invitation.save
                   { success: true, message: t('invitations.messages.was_sent') }
                 else
                   error = invitation.errors.messages.values.flatten.first
                   { success: false, message: error || t('invitations.messages.was_not_sent') }
                 end
    render json: result
  end

  def index
    @invitations = current_user.active_invitations
  end

  def sent
    @invitations = current_user.pending_invitations
    render :index
  end

  def rejected
    @invitations = current_user.rejected_invitations
    render :index
  end

  def accepted
    @invitations = current_user.accepted_invitations
    render :index
  end

  def accept
    authorize! :accept, @invitation
    @invitation.accept
    render nothing: true
  end

  def reject
    authorize! :reject, @invitation
    @invitation.reject_by_reason(params[:reason])
    render nothing: true
  end

  def counter
    authorize! :counter, @invitation
    render json: @invitation.make_counter_offer(params[:invitation][:amount].to_i)
  end

  def destroy
    authorize! :destroy, @invitation
    @invitation.destroy!
    render nothing: true
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invited_user_id, :message, :amount)
  end

  def find_invitation
    @invitation = Invitation.find(params[:id])
  end

end