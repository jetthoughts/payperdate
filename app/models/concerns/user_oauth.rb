module UserOauth

  def find_from_oauth oauth_info
    provider    = oauth_info.provider
    signup_info = send "prepare_info_for_#{provider}", oauth_info

    uid      = signup_info[:uid]
    token    = signup_info[:token]
    nickname = signup_info[:nickname]
    name     = signup_info[:name]
    email    = signup_info[:email]

    if (auth = Authentitication.where(provider: provider, uid: uid).first)
      auth.update_attribute(:access_token, token)
      auth.user
    else
      ActiveRecord::Base.transaction do
        user = User.create! nickname:     find_free_nickname(nickname),
                            email:        find_free_email(email, provider, uid),
                            name:         name,
                            password:     Devise.friendly_token[0, 20],
                            confirmed_at: Time.now,
                            no_password:  true
        user.authentitications.create! provider: provider, uid: uid, access_token: token
        user
      end
    end
  end

  private
  #TODO: Use birthday when they ask
  #facebook:
  #>>  request.env["omniauth.auth"].extra.raw_info.birthday
  #=> "07/03/1997"  = month/day/year!
  #twitter:
  #
  #
  def prepare_info_for_facebook(oauth_info)
    { uid:      oauth_info.uid.to_s,
      token:    oauth_info.credentials.token,
      nickname: oauth_info.info.nickname || "fbuser_#{uid}",
      name:     oauth_info.info.name,
      email:    oauth_info.info.email }
  end

  def prepare_info_for_twitter(oauth_info)
    { uid:      oauth_info.extra.access_token.params[:user_id].to_s,
      token:    oauth_info.extra.access_token.token,
      nickname: oauth_info.info.nickname || "twitter_user_#{uid}",
      name:     oauth_info.info.name,
      email:    nil }
  end

  def find_free_nickname nn
    res     = nn
    counter = 2
    while User.where(nickname: res).exists? do
      res     = nn + counter.to_s
      counter += 1
    end
    res
  end

  def find_free_email em, provider, uid
    if em.present? && User.where(email: em).empty?
      em
    else
      "dummy_#{provider}_#{uid}@dummy.com"
    end
  end

end