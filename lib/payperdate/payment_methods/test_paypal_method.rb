class TestPaypalMethod

  def setup_purchase(amount, params)
    TestPaypalResponse.new(params)
  end

  def purchase(amount, params)
    TestPaypalResponse.new(params)
  end

  def redirect_url_for(token)
    "http://paypal.com?#{token}"
  end

  private

  class TestPaypalResponse
    def initialize(params)
      @params = params
    end

    def token
      @params[:token]
    end

    def return_url
      @params[:return_url].to_s
    end

    def success?
      (token && token == 'valid') || return_url.present?
    end

    def params
      { 'payment_status' => 'Completed', 'token' => 'token' }
    end

    def message
      success? ? 'All good' : 'not enough money'
    end

  end

end