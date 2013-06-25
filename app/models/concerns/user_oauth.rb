module UserOauth

  def find_from_oauth oauth_info
    provider    = oauth_info.provider
    signup_info = prepare_signup_info_for(provider, oauth_info)

    uid      = signup_info[:uid]
    token    = signup_info[:token]
    nickname = signup_info[:nickname]
    name     = signup_info[:name]
    email    = signup_info[:email] || "dummy_#{uid}@dummy.com"
    if (auth = Authentitication.where(provider: provider, uid: uid).first)
      auth.update_attribute(:access_token, token)
      auth.user
    else
      ActiveRecord::Base.transaction do
        user = User.create! name:         name,
                            nickname:     nickname,
                            email:        email,
                            password:     Devise.friendly_token[0, 20],
                            confirmed_at: Time.now
        user.authentitications.create :provider => provider, uid: uid, access_token: token
        user
      end
    end
  end

  private

  def prepare_signup_info_for(provider, oauth_info)
    if provider == 'facebook'
      { uid:      oauth_info.uid.to_s,
        token:    oauth_info.credentials.token,
        nickname: oauth_info.info.nickname || "fbuser_#{uid}",
        name:     oauth_info.info.name,
        email:    oauth_info.info.email }
    elsif provider == 'twitter'
      { uid:      oauth_info.extra.access_token.params[:user_id].to_s,
        token:    oauth_info.extra.access_token.token,
        nickname: oauth_info.info.nickname || "twitter_user_#{uid}",
        name:     oauth_info.info.name,
        email:    nil }
    end

  end

end