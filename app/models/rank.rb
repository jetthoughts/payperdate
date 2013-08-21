class Rank < ActiveRecord::Base

  validates :name, :value, uniqueness: true, presence: true

end
