require 'test_helper'

class BaseControllerTest < ActionController::TestCase

  def test_state_of_invalid_model
    errors = stub('errors')
    errors.stubs('any?').returns(true)
    errors.stubs('full_messages').returns(['test error'])

    model = stub('model')
    model.stubs(:errors).returns(errors)

    result = @controller.send(:state_of_model, model)

    refute result[:success]
    assert_equal 'test error', result[:message]
  end

  def test_state_of_valid_model
    errors = stub('errors')
    errors.stubs('any?').returns(false)

    model = stub('model')
    model.stubs(:errors).returns(errors)

    result = @controller.send(:state_of_model, model)

    assert result[:success]
    assert_match /messages\.was_sent/, result[:message]
  end

end
