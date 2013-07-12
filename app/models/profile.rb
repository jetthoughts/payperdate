require 'hstore'

class Profile < ActiveRecord::Base
  extend HstoreValidator
  extend HstoreSearch
  include HstoreProperties

  belongs_to :user

  belongs_to :avatar

  @@config_params = YAML.load_file 'config/profile_params.yml'

  def self.editable_params 
    @@config_params[:editable]
  end

  def self.searchable_params
    @@config_params[:searchable]
  end

  # general_info validations
  hstore_validates_presence_of 'general_info.address_line_1',
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

  hstore_validates_presence_of 'date_preferences.accepted_distance' do |p|
    p.date_preferences &&
      p.date_preferences['accepted_distance_do_care'] == 'true'
  end

  geocoded_by :full_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  def full_address
    return nil unless general_info

    attrs = general_info.slice('address_line_1', 'city', 'state', 'zip_code').symbolize_keys
    I18n.t 'profile.address.full', attrs
  end

  # optional info validations
  # none for now

  def filled?
    general_info && personal_preferences &&
      date_preferences && optional_info
  end

  def avatar_url(version=:avatar)
    (avatar || Avatar.new).image_url(version)
  end
end
