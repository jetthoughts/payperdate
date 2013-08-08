class PaypalMethod

  def setup_purchase(amount, params)
    instance.setup_purchase(amount, params)
  end

  def purchase(amount, params)
    instance.purchase(amount, params)
  end

  def redirect_url_for(token)
    instance.redirect_url_for(token)
  end

  private

  def instance
    @instance ||= ActiveMerchant::Billing::Base.gateway(:paypal_express).new(Settings.paypal)
  end

end