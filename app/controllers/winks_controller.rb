class WinksController < BaseController

  # TODO: cover this by test
  def create
    wink = current_user.own_winks.build(wink_params)
    result = if wink.save
               { success: true, message: t('winks.messages.was_sent') }
             else
               error = wink.errors.full_messages.first
               { success: false, message: error || t('winks.messages.was_not_sent') }
             end
    render json: result
  end

  def index
    @winks = current_user.winks.page(params[:page] || 1)
  end

  private

  def wink_params
    params.require(:wink).permit(:wink_template_id, :recipient_id)
  end

end
