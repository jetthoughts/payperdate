require 'test_helper'

class CreditsControllerTest < ActionController::TestCase

  fixtures :users, :messages, :credits_packages

  def setup
    @user = users(:martin)
    sign_in @user
  end

  def test_add_credit_without_package
    assert_difference -> { Transaction.with_credits_package.count }, 0 do
      post :create, transaction: { some_param: 1 }
    end
  end

  def test_add_new_credit
    assert_difference -> { Transaction.with_credits_package.count }, +1 do
      post :create, transaction: { trackable_id: CreditsPackage.last.id }
      assert_redirected_to 'http://paypal.com?token'
    end
  end

  def test_success_complete_purchase
    credit = @user.credits.create(trackable_id: CreditsPackage.last.id)
    get :complete_purchase, id: credit.id, token: 'valid', PayerID: 'PayerID'
    assert_redirected_to credits_path
    assert credit.reload.purchased?
  end

  def test_bad_complete_purchase
    credit = @user.credits.create(trackable_id: CreditsPackage.last.id)
    get :complete_purchase, id: credit.id, token: 'invalid', PayerID: 'PayerID'
    assert_redirected_to credits_path
    assert credit.reload.failed?
  end

end
