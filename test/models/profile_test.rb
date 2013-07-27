require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :users, :profiles

  test 'should be invalid if address is incorrect' do
    profile = Profile.create  general_info_address_line_1: '5th avenue',
                              general_info_city: 'Fake city',
                              general_info_state: 'New Yourk',
                              general_info_zip_code: '11091'
    refute profile.valid_address?(true), 'should not be valid for incorrect address'
  end

  test 'should be valid if address is correct' do
    profile = Profile.create  general_info_address_line_1: '678 5th Ave',
                              general_info_city: 'New York',
                              general_info_state: 'NY',
                              general_info_zip_code: '10019'
    assert profile.valid_address?(true), 'should be valid for correct address'
  end

  test 'should be invalid after being valid if set to incorrect again' do
    profile = Profile.create  general_info_address_line_1: '678 5th Ave',
                              general_info_city: 'New York',
                              general_info_state: 'NY',
                              general_info_zip_code: '10019'
    profile.general_info_address_line_1 = '5th avenue'
    profile.general_info_city = 'Fake city'
    profile.general_info_state = 'New Yourk'
    profile.general_info_zip_code = '11091'
    profile.save
    refute profile.valid_address?(true), 'should not be valid for incorrect address'
  end
end
