class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :authentitications, dependent: :destroy
  has_one :profile
  has_many :albums, dependent: :destroy

  validates :nickname, :name, presence: true
  validates :nickname, uniqueness: true
  validates :phone, uniqueness: true, allow_nil: true

  after_create { build_profile.save! }

  attr_accessor :distance

  include UserAuthMethods
  extend UserOauth

  def self.find_for_database_authentication(conditions = {})
    find_by_login(conditions[:email])
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    (login = conditions.delete(:email)) ? find_by_login(login) : self.where(conditions).first
  end

  def self.find_by_login(login)
    self.where(email: login).limit(1).first || self.where(nickname: login).limit(1).first
  end
end
