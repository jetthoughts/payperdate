class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: {scope: :user_id}
end
