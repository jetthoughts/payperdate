require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :users, :profiles, :profile_multiselects

  test 'should be invalid if address is incorrect' do
    profile = Profile.create  general_info_address_line_1: '5th avenue',
                              general_info_city: 'Fake city',
                              general_info_state: 'New Yourk',
                              general_info_zip_code: '11091'
    refute profile.valid_address?, 'should not be valid for incorrect address'
  end

  test 'should be valid if address is correct' do
    profile = Profile.create  general_info_address_line_1: '678 5th Ave',
                              general_info_city: 'New York',
                              general_info_state: 'NY',
                              general_info_zip_code: '10019'
    assert profile.valid_address?, 'should be valid for correct address'
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
    refute profile.valid_address?, 'should not be valid for incorrect address'
  end

  test 'should be valid if zip code exists in geocode response and invalid' do
    profile = Profile.create general_info_address_line_1: '8 Rue de Londres',
                             general_info_city: 'Paris',
                             general_info_state: 'France',
                             general_info_zip_code: '75009'
    assert_equal profile.obtained_zipcode, '75009'
    assert profile.valid_zipcode?
  end

  test 'should be invalid if zip code exists in geocode response and invalid' do
    profile = Profile.create general_info_address_line_1: '8 Rue de Londres',
                             general_info_city: 'Paris',
                             general_info_state: 'france',
                             general_info_zip_code: '75109'
    assert_equal profile.obtained_zipcode, '75009'
    refute profile.valid_zipcode?
  end

  test 'should be invalid if distance lesser or equal 0' do
    profile = profiles(:martins)
    profile.date_preferences_accepted_distance_do_care = 'true'
    profile.date_preferences_accepted_distance = 0
    refute profile.valid?
  end

  test 'should be invalid if age lesser or equal 0' do
    profile = profiles(:martins)
    profile.optional_info_birthday = Date.today + 15.year
    refute profile.valid?
  end

  # This should go away. This fields are not integers now, but selects.

  # test 'should be invalid if annual income lesser or equal 0' do
  #   profile = profiles(:martins)
  #   profile.optional_info_annual_income = -15
  #   refute profile.valid?
  # end

  # test 'should be invalid if annual net worth lesser or equal 0' do
  #   profile = profiles(:martins)
  #   profile.optional_info_net_worth = -15
  #   refute profile.valid?
  # end

  # test 'should be invalid if annual height lesser or equal 0' do
  #   profile = profiles(:martins)
  #   profile.optional_info_height = -15
  #   refute profile.valid?
  # end
end
