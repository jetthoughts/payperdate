class DateRanksController < BaseController

  before_filter :load_invitation
  before_filter :load_ranks, only: [:new, :create]

  def new
    authorize! :rank, @invitation
    @date_rank = @invitation.date_ranks.build user: current_user
  end

  def create
    authorize! :rank, @invitation
    @date_rank = @invitation.date_ranks.build date_ranks_attributes.merge(user: current_user)
    if @date_rank.save
      redirect_to accepted_invitations_path, notice: t('.ranked')
    else
      render 'new'
    end
  end

  private

  def load_ranks
    @ranks = Rank.order(:value).reverse_order
  end

  def load_invitation
    @invitation = Invitation.find(params[:invitation_id])
  end

  def date_ranks_attributes
    params.require(:date_rank).permit(:courtesy_rank_id, :punctuality_rank_id, :authenticity_rank_id)
  end
end
