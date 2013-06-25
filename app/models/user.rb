class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :username, :name, presence: true
  validates :username, uniqueness: true
  validates :phone, uniqueness: true, allow_nil: true

  include UserAuthMethods

end
