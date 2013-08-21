class Me::DateRanksController < BaseController

  before_filter :load_users_date
  before_filter :load_ranks, only: [:new, :create]

  def new
    authorize! :rank, @users_date
    @date_rank = @users_date.date_ranks.build user: current_user
  end

  def create
    authorize! :rank, @users_date
    @date_rank = @users_date.date_ranks.build date_ranks_attributes.merge(user: current_user)
    if @date_rank.save
      redirect_to users_dates_path, notice: t('.ranked')
    else
      render 'new'
    end
  end

  private

  def load_ranks
    @ranks = Rank.order(:value).reverse_order
  end

  def load_users_date
    @users_date = UsersDate.find(params[:users_date_id])
  end

  def date_ranks_attributes
    params.require(:date_rank).permit(:courtesy_rank_id, :punctuality_rank_id, :authenticity_rank_id)
  end
end
