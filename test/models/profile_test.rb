require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test 'should be invalid if address is incorrect' do
    profile = Profile.new general_info: { 'address_line_1' => '5th avenue',
                                          'city'           => 'Fake city',
                                          'state'          => 'New Yourk',
                                          'zip_code'       => '11091' }
    refute_predicate profile, :valid_address?, 'should not be valid for incorrect address'
  end

  test 'should be valid if address is correct' do
    profile = Profile.new general_info: { 'address_line_1' => '678 5th Ave',
                                          'city'           => 'New York',
                                          'state'          => 'NY',
                                          'zip_code'       => '10019' }
    assert_predicate profile, :valid_address?, 'should be valid for correct address'
  end
end
