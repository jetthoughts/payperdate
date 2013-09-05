require 'test_helper'

class UpdateOnlineTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'should update user online on requesting pages' do
    martin = users(:martin)
    sign_in martin
    visit '/'
    assert martin.reload.online?
    Timecop.travel(1.minute) do
      assert martin.reload.online?
    end
    Timecop.travel(2.minute) do
      refute martin.reload.online?
      visit '/'
      assert martin.reload.online?
    end
  end
end
