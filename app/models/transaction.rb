class Transaction < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  belongs_to :owner, polymorphic: true
  belongs_to :recipient, polymorphic: true

  alias_attribute :credits_package, :trackable
  alias_attribute :user, :owner

  after_initialize :setup_trackable

  cattr_accessor :default_paypal_method

  scope :processed, -> { where { { state.not_eq => 'pending' } } }
  scope :with_credits_package, -> { where { { trackable_type => 'CreditsPackage'}} }

  validates :credits_package, presence: true

  state_machine :state, :initial => :pending do
    event :purchase do
      transition pending: :purchased
    end

    event :failure do
      transition pending: :failed
    end

    after_transition pending: :purchased do |transaction, transition|
      transaction.after_purchased
    end
  end

  def after_purchased
    self.owner.add_credits(self.amount)
  end

  def start_purchase(return_url, cancel_return_url)
    response = paypal.setup_purchase(credits_package.price_cents, { return_url:        return_url,
                                                    cancel_return_url: cancel_return_url,
                                                    description:       description,
                                                    currency:          credits_package.price_currency })
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
    response = paypal.purchase(credits_package.price_cents, { token: token,
                                                              payer_id: payer_id,
                                                              description: description,
                                                              currency: credits_package.price_currency })
    self.transaction_id = response.params['transaction_id']
    if response.success? && response.params['payment_status'] == 'Completed'
      purchase
    else
      self.error = "PayPal Error: #{response.message}"
      failure
    end
  end

  def action
    if trackable.is_a? UsersDate
      I18n.t("credit_transaction.keys.#{key}",
            name: owner.name,
            username: recipient.name,
            amount: "#{amount} #{'credit'.pluralize(amount)}")
    elsif trackable.is_a? CreditsPackage
      I18n.t("credit_transaction.keys.#{key}",
             name: trackable.to_s,
             username: owner.name,
             amount: amount)
    else
      I18n.t("credit_transaction.keys.#{key}",
             name: trackable.to_s,
             username: recipient.name,
             amount: amount)
    end
  end

  private

  def setup_trackable
    if trackable_type == 'CreditsPackage'
      self.amount = trackable.credits if trackable
      self.key    = :purchased_credits
    end
  end

  def paypal
    @paypal ||= self.class.default_paypal_method || PaypalMethod.new
  end

  def description
    credits_package.to_s
  end

end
