class FavoriteMailer < BaseMailer

  def new_favorite(favorite_id)
    @favorite = Favorite.find(favorite_id)
    return unless @favorite.favorite.settings.notify_added_to_favorites?
    mail(to: @favorite.favorite.email, subject: t('favorite.mailer.favoured'))
  end

end
