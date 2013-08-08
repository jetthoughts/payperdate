class Credit < ActiveRecord::Base
  belongs_to :credits_package
  belongs_to :user
  validates :description, :user, presence: true
  delegate :credits, :price_cents, :price_currency, to: :credits_package

  cattr_accessor :default_paypal_method

  scope :processed, -> { where { { state.not_eq => 'pending' } } }

  state_machine :state, :initial => :pending do
    event :purchase do
      transition pending: :purchased
    end

    event :failure do
      transition pending: :failed
    end

    after_transition pending: :purchased do |credit, transition|
      credit.user.add_credits(credit.credits)
    end

  end

  def start_purchase(return_url, cancel_return_url)
    response = paypal.setup_purchase(price_cents, { return_url:        return_url,
                                                    cancel_return_url: cancel_return_url,
                                                    description:       description,
                                                    currency:          price_currency })
    redirect_url = false
    if response.success?
      redirect_url = paypal.redirect_url_for(response.params['token'])
    end
    if !redirect_url
      errors.add(:base, "PayPal Error: #{response.message}")
    end
    redirect_url
  end

  def complete_purchase(token, payer_id)
    response = paypal.purchase(price_cents, { token: token, payer_id: payer_id, description: description, currency: price_currency })
    self.transaction_id = response.params['transaction_id']
    if response.success? && response.params['payment_status'] == 'Completed'
      purchase
    else
      self.error = "PayPal Error: #{response.message}"
      failure
    end
  end

  private

  def paypal
    @paypal ||= self.class.default_paypal_method || PaypalMethod.new
  end

  def description
    credits_package.to_s
  end

end
