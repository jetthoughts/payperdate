class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable

  has_many :authentitications, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :own_invitations, class_name: 'Invitation'

  belongs_to :profile, dependent: :destroy
  belongs_to :published_profile, class_name: 'Profile'

  validates :nickname, :name, presence: true
  validates :nickname, uniqueness: true
  validates :phone, uniqueness: true, allow_nil: true

  before_create { create_profile }
  before_create { create_published_profile }

  scope :active, -> { where('not blocked or blocked is null') }
  scope :blocked, -> { where(blocked: true) }
  scope :abuse, -> { where(abuse: true) }

  attr_accessor :distance

  include UserAuthMethods
  include InvitationsMethods
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

  def blocked?
    blocked
  end

  def block!
    update! blocked: true
    notify_account_was_blocked
  end

  def unblock!
    update! blocked: false
  end

  def delete_account!
    destroy!
    notify_account_was_deleted
  end

  private

  def notify_account_was_blocked
    NotificationMailer.user_was_blocked(id)
  end

  def notify_account_was_deleted
    NotificationMailer.user_was_deleted(email, name)
  end
end
