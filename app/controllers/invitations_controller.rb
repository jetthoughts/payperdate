class InvitationsController < BaseController

  before_action :find_invitation, only: [:accept, :reject, :counter, :destroy, :unlock]

  # TODO: cover this by test
  def create
    invitation = current_user.own_invitations.build(invitation_params)
    result     = if invitation.save
                   { success: true, message: t('invitations.messages.was_sent') }
                 else
                   error = invitation.errors.full_messages.flatten.first
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

  # TODO: cover this by test
  def rejected
    @invitations = current_user.rejected_invitations
    render :index
  end

  # TODO: cover this by test
  def accepted
    @invitations = current_user.accepted_invitations
    render :index
  end

  def accept
    authorize! :accept, @invitation
    @invitation.accept_with_message(params[:message])
    #TODO: AJAX
    redirect_to accepted_invitations_path
  end

  # TODO: cover this by test
  def reject
    authorize! :reject, @invitation
    @invitation.reject_by_reason(params[:reason])
    render nothing: true
  end

  # TODO: cover this by test
  def counter
    authorize! :counter, @invitation
    render json: @invitation.make_counter_offer(params[:invitation][:amount].to_i)
  end

  # TODO: cover this by test
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
