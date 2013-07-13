require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test 'should be invalid if address is incorrect' do
    profile = Profile.create general_info: { 'address_line_1' => '5th avenue',
                                             'city'           => 'Fake city',
                                             'state'          => 'New Yourk',
                                             'zip_code'       => '11091' },
                             user_id: users(:paul).id
    refute profile.valid_address?(true), 'should not be valid for incorrect address'
  end

  test 'should be valid if address is correct' do
    profile = Profile.create general_info: { 'address_line_1' => '678 5th Ave',
                                             'city'           => 'New York',
                                             'state'          => 'NY',
                                             'zip_code'       => '10019' },
                             user_id: users(:paul).id
    assert profile.valid_address?(true), 'should be valid for correct address'
  end

  test 'should be invalid after being valid if set to incorrect again' do
    profile = Profile.create general_info: { 'address_line_1' => '678 5th Ave',
                                             'city'           => 'New York',
                                             'state'          => 'NY',
                                             'zip_code'       => '10019' },
                             user_id: users(:paul).id
    profile.general_info = { 'address_line_1' => '5th avenue',
                             'city'           => 'Fake city',
                             'state'          => 'New Yourk',
                             'zip_code'       => '11091' }
    profile.save
    refute profile.valid_address?(true), 'should not be valid for incorrect address'
  end
end
