ActiveMerchant::Billing::Base.mode = Settings.paypal.mode
if Rails.env.test?
  require 'payperdate/payment_methods/test_paypal_method'
  Credit.default_paypal_method = TestPaypalMethod.new
else
  require 'payperdate/payment_methods/paypal_method'
  Credit.default_paypal_method = PaypalMethod.new
end