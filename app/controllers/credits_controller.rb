class CreditsController < BaseController

  def index
    @credits = current_user.transactions.page(params[:page] || 1)
  end

  def new
    @credit = Transaction.new
  end

  def create
    @credit = current_user.credits.build(credit_params)
    save_and_redirect_to_paypal @credit
  end

  def update
    @credit = Transaction.with_credits_package.find(params[:id])
    @credit.update_attributes(credit_params)
    save_and_redirect_to_paypal @credit
  end

  def complete_purchase
    @credit = Transaction.with_credits_package.find(params[:id])
    if @credit.complete_purchase(params[:token], params[:PayerID])
      redirect_to credits_path, notice: t('credits.was_added')
    else
      redirect_to credits_path, alert: @credit.error
    end
  end

  private

  def credit_params
    params.require(:transaction).permit(:trackable_id)
  end

  def save_and_redirect_to_paypal credit
    redirect_url = @credit.save && @credit.start_purchase(complete_purchase_credit_url(@credit), new_credit_url)
    if redirect_url.present?
      redirect_to redirect_url
    else
      render :new
    end
  end

end
