module WinksMethods
  extend ActiveSupport::Concern
  included do
    has_many :winks, foreign_key: :recipient_id, dependent: :destroy
    has_many :own_winks, class_name: 'Wink'
  end

  def can_wink?(user)
    !operate_with_himself?(user) && !already_winked?(user)
  end

  def already_winked?(user)
    day_ago = 1.day.ago
    own_winks.where{{ created_at.gt => day_ago, recipient_id => user.id }}.any?
  end

  private


end