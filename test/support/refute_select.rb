module Payperdate::TestHelpers
  def refute_select(*args, &block)
    begin
      assert_select *args, &block
    rescue ::ActiveSupport::TestCase::Assertion
      return
    end
    raise ::ActiveSupport::TestCase::Assertion
  end
end
