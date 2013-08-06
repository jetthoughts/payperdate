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
    :optional_info_eye_color, :optional_info_hair_color, :optional_info_children,
    :optional_info_smoker, :optional_info_drinker, user_attributes: [:subscribed, :id]
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

  PROFANITY_CHECKED_PARAMS = [
      :general_info_address_line_1, :general_info_address_line_2, :general_info_city,
      :general_info_state, :general_info_zip_code, :general_info_tagline, :general_info_description,
      :date_preferences_description, :optional_info_occupation
  ]

  MODERATED_PARAMS = [
      :general_info_address_line_1, :general_info_address_line_2, :general_info_city,
      :general_info_state, :general_info_zip_code, :general_info_tagline, :general_info_description,
      :personal_preferences_sex, :date_preferences_description, :optional_info_occupation
  ]

  MAX_DISTANCE = 9999999

  has_one :user
  has_one :published_user, foreign_key: :published_profile_id, class_name: 'User'
  accepts_nested_attributes_for :user

  belongs_to :avatar

  attr_accessor :obtained_zipcode

  has_many :profile_notes

  def nickname
    auto_user && auto_user.nickname
  end

  belongs_to :avatar

  scope :approve_queue, -> { where reviewed: false }
  scope :published, -> {
    joins('INNER JOIN "users" on "users"."published_profile_id" = "profiles"."id"')
        .where(filled: true)
  }
  scope :published_and_active, -> { published.where("users.state = 'active'") }

  attr_accessor :obtained_zipcode

  attr_accessor :inner_dont_care_about_review_notifications

  def self.not_mine(profile)
    where('users.id != ?', profile.auto_user.id)
  end

  def self.editable_params
    EDITABLE_PARMAS
  end

  def self.searchable_params
    SEARCHABLE_PARAMS
  end

  def self.profanity_checked_params
    PROFANITY_CHECKED_PARAMS
  end

  def self.moderated_params
    MODERATED_PARAMS
  end

  after_save :cache_filled

  validates_presence_of :general_info_address_line_1, :general_info_city, :general_info_state,
                        :general_info_zip_code, :general_info_tagline, :general_info_description,
                        :personal_preferences_sex, :personal_preferences_partners_sex,
                        :personal_preferences_relationship, :personal_preferences_want_relationship,
                        :date_preferences_accepted_distance_do_care, :date_preferences_smoker,
                        :date_preferences_drinker, :date_preferences_description, if: :filled?

  validates :date_preferences_accepted_distance, presence: true, numericality: { greater_than: 0 }, if: :distance_do_care?
  validates :optional_info_age, presence: true, numericality: { greater_than: 16 }, if: :filled?
  validates :optional_info_annual_income, :optional_info_net_worth, :optional_info_height, numericality: { greater_than: 0 }, allow_blank: true
  validate :validate_address, if: :filled?

  scope :active, -> { joins(:user).where("users.state = 'active'") }
  after_save :enqueue_for_approval, if: :free_form_fields_changed?

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
      raise 'Geocoding should not be run when testing' if Rails.env.test?
      reset_geocoding!
      geocode
    end
  end

  def location_changed?
    [:general_info_state, :general_info_city, :general_info_zip_code, :general_info_address_line_1,
         :general_info_address_line_2].any? { |e| changes.keys.include? e.to_s }
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
    if general_info_address_line_1 && personal_preferences_sex && date_preferences_accepted_distance_do_care
      true
    else
      false
    end
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
    update! reviewed: true
    published_version.update! get_attributes
    notify_user_about_review_status :approved unless inner_dont_care_about_review_notifications
  end

  def enqueue_for_approval
    if current_version? && filled?
      if reviewed || reviewed.nil?
        self.reviewed = false
        update! reviewed: false
        notify_user_about_review_status :queued unless inner_dont_care_about_review_notifications
      end
    end
  end

  # hotfix
  def user_id
    auto_user && auto_user.id
  end

  def profane?
    Profile.profanity_checked_params.any? { |e| Obscenity.profane? send e }
  end

  def get_attributes
    column_names = Profile.column_names - ['id', 'created_at', 'updated_at']
    attributes   = { }
    column_names.each { |name| attributes[name.to_sym] = send(name.to_sym) }
    attributes
  end

  def name
    auto_user && "#{auto_user.name}'s Profile" || "Somebody's profile"
  end

  def cache_filled
    if filled != filled?
      update! filled: filled?
    end
  end

  def current_version
    auto_user && auto_user.profile
  end

  def published_version
    auto_user && auto_user.published_profile
  end

  def current_version?
    current_version && current_version.id == id
  end

  def published_version?
    published_version && published_version.id == id
  end

  def auto_user
    user || published_user
  end

  def cache_filled
    if filled != filled?
      update! filled: filled?
    end
  end

  def next_queued_for_approval
    Profile.approve_queue.where('id > ?', id).order('id ASC').first
  end

  def prev_queued_for_approval
    Profile.approve_queue.where('id < ?', id).order('id DESC').first
  end

  private

  def notify_user_about_review_status(status)
    NotificationMailer.review_status_changed(user_id, status)
  end

  def free_form_fields_changed?
    Profile.moderated_params.any? { |e| changes.keys.include? e.to_s }
  end

  def validate_address
    errors.add(:address, I18n.t('profiles.errors.invalid_address')) if !valid_address?
    errors.add(:address, I18n.t('profiles.errors.invalid_zipcode', zipcode: obtained_zipcode)) if !valid_zipcode?
  end

end
