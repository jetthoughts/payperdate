class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable

  has_many :authentitications, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :own_invitations, class_name: 'Invitation'
  has_many :gifts, foreign_key: :recipient_id, dependent: :destroy
  has_many :sended_gifts, class_name: "Gift", dependent: :destroy
  has_many :member_reports, foreign_key: :reported_user_id, dependent: :destroy
  has_many :messages_sent, class_name: 'Message', inverse_of: :sender, foreign_key: :sender_id
  has_many :messages_received, class_name: 'Message', inverse_of: :recipient, foreign_key: :recipient_id

  has_many :credits, ->{ where(trackable_type: "CreditsPackage") }, as: :owner, class_name: "Transaction"

  has_many :block_relationships
  has_many :blocked_users, through: :block_relationships, source: :target

  has_many :transactions, as: :owner
  has_many :recivied_transactions, class_name: "Transaction", as: :recipient

  has_many :date_ranks, inverse_of: :user

  belongs_to :avatar, inverse_of: :owner
  belongs_to :profile, dependent: :destroy
  belongs_to :published_profile, class_name: 'Profile'

  validates :nickname, :name, presence: true
  validates :nickname, uniqueness: true
  validates :phone, uniqueness: true, allow_nil: true

  before_create { create_profile }
  before_create { create_published_profile }
  after_save :update_subscription, if: :subscribed_changed?
  after_save :enqueue_for_approval, if: :free_form_fields_changed?

  scope :reverse_order, -> { order('users.created_at DESC, users.id DESC') }
  scope :active, -> { where(state: 'active', deleted_state: 'none') }
  scope :deleted, -> { where "deleted_state != 'none'" }
  scope :non_deleted, -> { where deleted_state: 'none' }
  scope :blocked, -> { where(state: 'blocked', deleted_state: 'none') }
  scope :abuse, -> { where(abuse: true) }
  scope :subscribed, -> { where(subscribed: true) }
  scope :unsubscribed, -> { where(subscribed: false) }

  scope :by_sex, ->(sex) {
    joins(:profile).where(Profile.arel_table[:personal_preferences_sex].in(sex))
  }

  scope :reviewed, -> {
    joins(:profile).where(Profile.arel_table[:reviewed].eq(true))
  }
  scope :not_reviewed, -> {
    joins(:profile).where(Profile.arel_table[:reviewed].eq(false))
  }

  scope :confirmed, -> { where("confirmed_at IS NOT NULL") }
  scope :not_confirmed, -> { where("confirmed_at IS NULL") }

  scope :have_avatar, -> {
    joins(:profile).where(Profile.arel_table[:avatar_id].not_eq(nil))
  }

  scope :not_have_avatar, -> {
    joins(:profile).where(Profile.arel_table[:avatar_id].eq(nil))
  }

  scope :activity_more_than, ->(days) {
    where(arel_table[:last_sign_in_at].lt(Time.now - days.to_i.days))
  }

  # TODO: check if this is covered by test.
  def self.by_age_ranging(start_age, end_age)
    if start_age or end_age
      birthday_field = Profile.arel_table[:optional_info_birthday]
      conditions = birthday_field.eq(nil)
      conditions = conditions.or(birthday_field.gteq(Date.today - end_age.to_i.year)) if end_age
      conditions = conditions.or(birthday_field.lteq(Date.today - start_age.to_i.year)) if start_age
    end

    joins(:profile).where(conditions)
  end

  state_machine :state, initial: :active do
    after_transition any => :blocked, do: :notify_account_was_blocked
    after_transition :blocked => :active, do: :enqueue_archived_profile_for_approval

    event :block! do
      transition all => :blocked
    end

    event :unblock! do
      transition all => :active
    end

    state :active
    state :blocked
  end

  state_machine :deleted_state, initial: :none do
    after_transition any => :deleted_by_admin, do: :notify_account_was_deleted
    after_transition deleted_by_himself: :none, do: :notify_account_was_restored
    after_transition deleted_by_admin: :none, do: :notify_account_was_restored
    after_transition any => :none, do: :enqueue_archived_profile_for_approval

    event :delete! do
      transition all => :deleted_by_himself
    end

    event :delete_by_admin! do
      transition all => :deleted_by_admin
    end

    event :restore! do
      transition all => :none
    end

    state :none
    state :deleted_by_himself
    state :deleted_by_admin
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

  def can_communicated_with?(user)
    communication = UsersCommunication.where(["(owner_id = ? AND recipient_id = ?) OR (owner_id = ? AND recipient_id = ?)",self.id,user.id,user.id,self.id]).first
    communication && communication.unlocked || false
  end

  def unsubscribe!
    update! subscribed: true
  end

  def subscribe!
    update! subscribed: false
  end

  def block_user(user)
    blocked_users << user
  end

  def unblock_user(user)
    blocked_users.delete(user)
  end

  def blocked_for?(user)
    user.blocked_users.include?(self)
  end

  def deleted?
    deleted_by_himself? || deleted_by_admin?
  end

  def female?
    #FIXME: Using string is bad idea. Extract to constant
    profile.personal_preferences_sex == 'F'
  end

  def first_name
    name.split(/[\s,]+/)[0]
  end

  #TODO: das ist fantastisch
  def age
    published_profile && published_profile.filled? && published_profile.optional_info_age || 22
  end

  def enqueue_for_approval
    profile.enqueue_for_approval
  end

  def operate_with_himself?(user)
    id == user.id
  end

  #TODO: Add tests
  def avatar_url(version=:avatar, public_avatar = true)
    av = public_avatar ? avatar && avatar.public_photo : avatar
    (av || Avatar.new).image_url(version)
  end

  def add_credits(credits_count)
    update!(credits_amount: self.credits_amount + credits_count)
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

  def notify_account_was_restored
    NotificationMailer.user_was_restored(email, name)
  end

  def enqueue_archived_profile_for_approval
    profile && profile.enqueue_for_approval
    published_profile && published_profile.update_attributes!(reviewed: false)
  end

  def free_form_fields_changed?
    [name_changed?, nickname_changed?].any?
  end
end
