ActiveMerchant::Billing::Base.mode = Settings.paypal.mode
if Rails.env.test?
  require 'payperdate/payment_methods/test_paypal_method'
  Transaction.default_paypal_method = TestPaypalMethod.new
else
  require 'payperdate/payment_methods/paypal_method'
  Transaction.default_paypal_method = PaypalMethod.new
end
