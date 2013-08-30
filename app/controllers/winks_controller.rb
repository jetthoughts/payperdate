class WinksController < BaseController

  before_filter :load_user, only: :create

  def create
    wink = current_user.own_winks.create(wink_params.merge(recipient: @user))
    render json: state_of_model(wink)
  end

  def index
    @winks = current_user.winks.page(params[:page] || 1)
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def wink_params
    params.require(:wink).permit(:wink_template_id)
  end

end
