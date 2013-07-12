require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test 'should validate address' do
    skip
    profile = Profile.create general_info: { 'address_line_1' => '5th avenue',
                                             'city'           => 'New Yourk',
                                             'state'          => 'New Yourk' }
    refute_predicate profile, :valid?, 'should not be valid for incorrect address'
  end
end
