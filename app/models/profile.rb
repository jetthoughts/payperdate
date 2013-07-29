class Profile < ActiveRecord::Base
  EDITABLE_PARMAS = [
      :general_info_address_line_1, :general_info_address_line_2, :general_info_city,
      :general_info_state, :general_info_zip_code, :general_info_tagline,
      :general_info_description, :personal_preferences_sex, :personal_preferences_partners_sex,
      :personal_preferences_relationship, :personal_preferences_want_relationship,
      :date_preferences_accepted_distance, :date_preferences_accepted_distance_do_care,
      :date_preferences_smoker, :date_preferences_drinker, :date_preferences_description,
      :optional_info_age, :optional_info_education, :optional_info_occupation,
      :optional_info_annual_income, :optional_info_net_worth, :optional_info_height,
      :optional_info_body_type, :optional_info_religion, :optional_info_ethnicity,
      :optional_info_eye_color, :optional_info_hair_color, :optional_info_address,
      :optional_info_children, :optional_info_smoker, :optional_info_drinker
  ]

  SEARCHABLE_PARAMS = {
      primary: [
                   { section: 'personal_preferences', key: 'sex', type: :select, subtype: 'sex' },
                   { section: 'optional_info', key: 'age', type: :range },
                   { section: 'general_info', key: 'city', type: :string },
                   { section: 'general_info', key: 'state', type: :string }
               ],
      hidden:  [
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

  # belongs_to :user
  has_one :user
  has_one :published_user, foreign_key: :published_profile_id, class_name: 'User'

  # has_one :current_version, through: :published_user, class_name: 'Profile', foreign_key: :profile_id
                               # has_one :published_version, through: :user, class_name: 'Profile', foreign_key: :published_profile_id

  belongs_to :avatar

  attr_accessor :obtained_zipcode

  def self.editable_params
    EDITABLE_PARMAS
  end

  def self.searchable_params
    SEARCHABLE_PARAMS
  end

  before_validation { self.filled = filled? }

  validates_presence_of :general_info_address_line_1,
                        :general_info_city,
                        :general_info_state,
                        :general_info_zip_code,
                        :general_info_tagline,
                        :general_info_description,
                        :personal_preferences_sex,
                        :personal_preferences_partners_sex,
                        :personal_preferences_relationship,
                        :personal_preferences_want_relationship,
                        :date_preferences_accepted_distance_do_care,
                        :date_preferences_description,
                        if: :filled?

  validates :date_preferences_accepted_distance, presence: true, numericality: { greater_than: 0 }, if: :distance_do_care?
  validates :optional_info_age, presence: true, numericality: { greater_than: 16 }, if: :filled?
  validates :optional_info_annual_income, :optional_info_net_worth, :optional_info_height, numericality: { greater_than: 0 }, allow_blank: true
  validate :validate_address, if: :filled?

  scope :active, -> { joins(:user).where('users.blocked == false') }

  geocoded_by :full_address do |obj, results|
    if (geo = results.first)
      if (location = geo.geometry['location'])
        obj.latitude  = location['lat']
        obj.longitude = location['lng']
      end
      obj.obtained_zipcode = geo.postal_code
    end
  end

  before_validation :regeocode # auto-fetch coordinates

  def full_address
    attrs = [:general_info_address_line_1, :general_info_city, :general_info_state, :general_info_zip_code]
    return nil unless attrs.all? { |e| send e }
    I18n.t 'profile.address.full', get_attributes.slice(*attrs)
  end

  def valid_address?
    latitude && longitude && valid_zipcode?
  end

  def valid_zipcode?
    obtained_zipcode.nil? || obtained_zipcode == general_info_zip_code
  end

  def regeocode
    if location_changed?
      reset_geocoding!
      geocode
      if valid_address?
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
    self.latitude  = nil
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
    res['max_distance'] = date_preferences_accepted_distance if distance_do_care?
    res
  end

  def filled?
    general_info_address_line_1 && personal_preferences_sex && date_preferences_accepted_distance_do_care
  end

  def avatar_url(version=:avatar, public_avatar = true)
    if public_avatar
      (avatar && avatar.public_photo || Avatar.new).image_url(version)
    else
      (avatar || Avatar.new).image_url(version)
    end
  end

  def distance_do_care?
    filled? && date_preferences_accepted_distance_do_care == 'true'
  end

  def reviewed?
    reviewed
  end

  def approve!
    update! reviewed = true
    published_version.update! get_attributes
  end

  def enqueue_for_approval
    reviewed = false
  end

  # hotfix
  def user_id
    user.id
  end

  private

  def get_attributes
    column_names = Profile.column_names - ['id', 'created_at', 'updated_at']
    attributes   = { }
    column_names.each { |name| attributes[name.to_sym] = send(name.to_sym) }
    attributes
  end

  def name
    "#{user.name}'s Profile"
  end

  def validate_address
    errors.add(:address, I18n.t('profiles.errors.invalid_address')) if !valid_address?
    errors.add(:address, I18n.t('profiles.errors.invalid_zipcode', zipcode: obtained_zipcode)) if !valid_zipcode?
  end

end
