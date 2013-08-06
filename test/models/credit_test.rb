require 'test_helper'

class CreditTest < ActiveSupport::TestCase
  fixtures :users, :credits_packages, :credits

   test 'add credits amount to user when credit was purchased' do
     martin = users(:martin)
     credit = martin.credits.create!(credits_package: credits_packages(:standart))
     assert_difference 'martin.reload.credits_amount', +10 do
       credit.purchase
     end
   end

  test 'success complete_paypal' do
    credit = credits(:martins_pending)
    credit.complete_purchase('valid', 'valid')
    assert credit.purchased?
    assert_equal nil, credit.error
  end

  test 'failed complete_paypal' do
    credit = credits(:martins_pending)
    credit.complete_purchase('invalid', 'invalid')
    assert credit.failed?
    assert_equal 'PayPal Error: not enough money', credit.error
  end

  test 'success start_paypal' do
    credit = credits(:martins_pending)
    assert_equal 'http://paypal.com?token', credit.start_purchase('http://localhost:3000/credits/1', '')
  end

  test 'failed start_paypal' do
    credit = credits(:martins_pending)
    refute credit.start_purchase('', '')
  end
end
