class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,
    :validatable, :confirmable, :omniauthable

  has_many :authentitications, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :own_invitations, class_name: 'Invitation'
  has_many :gifts, foreign_key: :recipient_id, dependent: :destroy
  has_many :member_reports, foreign_key: :reported_user_id, dependent: :destroy
  has_many :messages_sent, class_name: 'Message', inverse_of: :sender, foreign_key: :sender_id
  has_many :messages_received, class_name: 'Message', inverse_of: :recipient, foreign_key: :recipient_id

  belongs_to :avatar, inverse_of: :owner
  belongs_to :profile, dependent: :destroy
  belongs_to :published_profile, class_name: 'Profile'

  validates :nickname, :name, presence: true
  validates :nickname, uniqueness: true
  validates :phone, uniqueness: true, allow_nil: true

  before_create { create_profile }
  before_create { create_published_profile }
  after_save :update_subscription, if: :subscribed_changed?

  scope :reverse_order, -> { order('users.created_at DESC, users.id DESC') }
  scope :active, -> { where(state: 'active') }
  scope :blocked, -> { where(state: 'blocked') }
  scope :abuse, -> { where(abuse: true) }
  scope :subscribed,    -> { where(subscribed: true) }
  scope :unsubscribed,  -> { where(subscribed: false) }

  scope :by_sex,        ->(sex) {
    joins(:profile).where(Profile.arel_table[:personal_preferences_sex].in(sex))
  }

  scope :reviewed,      -> {
    joins(:profile).where(Profile.arel_table[:reviewed].eq(true))
  }
  scope :not_reviewed,  -> {
    joins(:profile).where(Profile.arel_table[:reviewed].eq(false))
  }

  scope :confirmed,     -> { where("confirmed_at IS NOT NULL") }
  scope :not_confirmed, -> { where("confirmed_at IS NULL") }

  scope :have_avatar,   -> {
    joins(:profile).where(Profile.arel_table[:avatar_id].not_eq(nil))
  }

  scope :not_have_avatar,   -> {
    joins(:profile).where(Profile.arel_table[:avatar_id].eq(nil))
  }

  scope :activity_more_than, ->(days) {
    where(arel_table[:last_sign_in_at].lt(Time.now - days.to_i.days))
  }

  def self.by_age_ranging(start_age, end_age)
    if start_age or end_age
      conditions = Profile.arel_table[:optional_info_age].eq(nil)
      conditions = conditions.or(Profile.arel_table[:optional_info_age].gteq(start_age)) if start_age
      conditions = conditions.or(Profile.arel_table[:optional_info_age].lteq(end_age)) if end_age
    end

    joins(:profile).where(conditions)
  end

  state_machine :state, initial: :active do
    after_transition any => :blocked, do: :notify_account_was_blocked

    event :block! do
      transition all => :blocked
    end

    event :unblock! do
      transition all => :active
    end

    state :active
    state :blocked
  end

  attr_accessor :distance

  include UserAuthMethods
  include InvitationsMethods
  include WinksMethods
  extend UserOauth

  include ActivityTracker

  def self.find_for_database_authentication(conditions = {})
    find_by_login(conditions[:email])
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    (login = conditions.delete(:email)) ? find_by_login(login) : self.where(conditions).first
  end

  def self.find_by_login(login)
    self.find_by(email: login) || self.find_by(nickname: login)
  end

  def unsubscribe!
    update! subscribed: true
  end

  def subscribe!
    update! subscribed: false
  end

  def delete_account!
    destroy!
    notify_account_was_deleted
  end

  def female?
    profile.personal_preferences_sex == 'F'
  end

  def first_name
    name.split(/[\s,]+/)[0]
  end

  def age
    22
  end

  def operate_with_himself?(user)
    id == user.id
  end

  def avatar_url(version=:avatar, public_avatar = true)
    av = public_avatar ? avatar && avatar.public_photo : avatar
    (av || Avatar.new).image_url(version)
  end

  private

  def update_subscription
    if subscribed
      MassMailer.add_subscribe self.email
    else
      MassMailer.remove_subscribe self.email
    end
  end

  def notify_account_was_blocked
    NotificationMailer.user_was_blocked(id)
  end

  def notify_account_was_deleted
    NotificationMailer.user_was_deleted(email, name)
  end
end
