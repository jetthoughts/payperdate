class Me::UsersDatesController < BaseController

  before_filter :load_users_date, only: :unlock

  def index
    @users_dates = UsersDate.by(current_user)
  end

  def unlocked
    @users_dates = UsersDate.by(current_user).unlocked
    render 'index'
  end

  def locked
    @users_dates = UsersDate.by(current_user).locked
    render 'index'
  end

  # TODO: cover this by test
  def unlock
    authorize! :unlock, @users_date
    @users_date.unlock
    flash[:alert] = @users_date.errors.full_messages.join(" ") if @users_date.errors.any?
    redirect_to users_dates_path
  end

  private

  def load_users_date
    @users_date = UsersDate.find(params[:id])
  end

end
