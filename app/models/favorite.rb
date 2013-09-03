class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite, class_name: 'User'

  after_commit :notify_favorite, on: :create

  private

  def notify_favorite
    FavoriteMailer.delay.new_favorite(self.id)
  end

end
