require 'hstore'

class Profile < ActiveRecord::Base
  extend HstoreValidator
  include HstoreProperties

  belongs_to :user

  # general_info validations
  hstore_validates_presence_of  'general_info.address_line_1',
                                'general_info.city',
                                'general_info.state',
                                'general_info.zip_code',
                                'general_info.tagline',
                                'general_info.description',
  # personal_preferences validations
                                'personal_preferences.sex',
                                'personal_preferences.partners_sex',
                                'personal_preferences.relationship',
                                'personal_preferences.want_relationship',
  # date_preferences validations
                                'date_preferences.accepted_distance_do_care',
                                'date_preferences.smoker',
                                'date_preferences.drinker',
                                'date_preferences.description' do |p|
    p.filled?
  end

  hstore_validates_presence_of  'date_preferences.accepted_distance' do |p|
    p.date_preferences &&
    p.date_preferences['accepted_distance_do_care'] == 'true'
  end

  # optional info validations
  # none for now

  def filled?
    general_info && personal_preferences &&
    date_preferences && optional_info
  end

end
