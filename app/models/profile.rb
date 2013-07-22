require 'hstore'

class Profile < ActiveRecord::Base
  extend HstoreValidator
  extend HstoreSearch
  include HstoreProperties

  EDITABLE_PARMAS = {
    general_info: [:address_line_1, :address_line_2, :city, :state, :zip_code,
                   :tagline, :description],
    personal_preferences: [:sex, :partners_sex, :relationship, :want_relationship],
    date_preferences: [:accepted_distance, :accepted_distance_do_care, :smoker,
                       :drinker, :description],
    optional_info: [:age, :education, :occupation, :annual_income, :net_worth,
                    :height, :body_type, :religion, :ethnicity, :eye_color,
                    :hair_color, :address, :children, :smoker, :drinker]
  }

  SEARCHABLE_PARAMS = {
    primary: [
      { section: 'personal_preferences', key: 'sex', type: :select, subtype: 'sex' },
      { section: 'optional_info', key: 'age', type: :range },
      { section: 'general_info', key: 'city', type: :string },
      { section: 'general_info', key: 'state', type: :string }
    ],
    hidden: [
      { section: 'personal_preferences', key: 'partners_sex', type: :select, subtype: 'sex' },
      { section: 'personal_preferences', key: 'relationship', type: :select, subtype: 'relationship' },
      { section: 'personal_preferences', key: 'want_relationship', type: :select, subtype: 'want_relationship' },
      { section: 'date_preferences', key: 'accepted_distance', type: :range },
      { section: 'optional_info', key: 'education', type: :select, subtype: 'education' },
      { section: 'optional_info', key: 'occupation', type: :string },
      { section: 'optional_info', key: 'annual_income', type: :range },
      { section: 'optional_info', key: 'net_worth', type: :range },
      { section: 'optional_info', key: 'height', type: :range },
      { section: 'optional_info', key: 'body_type', type: :select, subtype: 'body_type' },
      { section: 'optional_info', key: 'religion', type: :select, subtype: 'religion' },
      { section: 'optional_info', key: 'ethnicity', type: :select, subtype: 'ethnicity' },
      { section: 'optional_info', key: 'eye_color', type: :select, subtype: 'eye_color' },
      { section: 'optional_info', key: 'hair_color', type: :select, subtype: 'hair_color' },
      { section: 'optional_info', key: 'children', type: :select, subtype: 'children' },
      { section: 'optional_info', key: 'smoker', type: :select, subtype: 'me_smoker' },
      { section: 'optional_info', key: 'drinker', type: :select, subtype: 'me_drinker' }
    ]
  }

  MAX_DISTANCE = 9999999

  belongs_to :user

  belongs_to :avatar

  def self.editable_params
    EDITABLE_PARMAS
  end

  def self.searchable_params
    SEARCHABLE_PARAMS
  end

  before_validation { self.filled = filled? }

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

  validate :valid_address?, if: :filled?

  hstore_validates_presence_of 'date_preferences.accepted_distance' do |p|
    p.distance_do_care?
  end

  geocoded_by :full_address   # can also be an IP address
  before_validation :regeocode          # auto-fetch coordinates

  def full_address
    return nil unless general_info

    attrs = general_info.slice('address_line_1', 'city', 'state', 'zip_code').symbolize_keys
    I18n.t 'profile.address.full', attrs
  end

  def valid_address?(no_revalidation = false)
    unless latitude && longitude || no_revalidation
      errors.add(:address, I18n.t('profiles.errors.invalid_address'))
    end
    latitude && longitude
  end

  def regeocode
    if location_changed?
      reset_geocoding!
      geocode
      if valid_address?(true)
        cache_full_address!
      end
    end
  end

  def location_changed?
    full_address != full_address_saved
  end

  def cache_full_address!
    self.full_address_saved = full_address
  end

  def reset_geocoding!
    self.latitude = nil
    self.longitude = nil
  end

  def near_me(location, max_distance)
    distance = MAX_DISTANCE
    distance = max_distance unless max_distance.blank?
    res = Profile.where.not(id: id)
    if location.blank?
      res
    else
      res.geocoded.near(location, distance).order('distance')
    end
  end

  def default_search
    res = { 'location' => full_address }
    res['max_distance'] = date_preferences['accepted_distance'] if distance_do_care?
    res
  end

  def filled?
    general_info && personal_preferences &&
      date_preferences && optional_info
  end

  def avatar_url(version=:avatar, public_avatar=true)
    if public_avatar
      (avatar && avatar.public_photo || Avatar.new).image_url(version)
    else
      (avatar || Avatar.new).image_url(version)
    end
  end

  def distance_do_care?
    date_preferences && date_preferences['accepted_distance_do_care'] == 'true'
  end
end
