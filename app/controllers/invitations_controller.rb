class InvitationsController < BaseController

  before_filter :load_user, only: :create
  before_action :find_invitation, only: [:accept, :reject, :counter, :destroy]

  def create
    invitation = current_user.own_invitations.create(invitation_params.merge(invited_user: @user))
    render json: state_of_model(invitation)
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
    @invitation.accept_with_message(params[:message])
    #TODO: AJAX
    redirect_to accepted_invitations_path
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

  def load_user
    @user = User.find(params[:user_id])
  end

  def invitation_params
    params.require(:invitation).permit(:message, :amount)
  end

  def find_invitation
    @invitation = Invitation.find(params[:id])
  end

end
