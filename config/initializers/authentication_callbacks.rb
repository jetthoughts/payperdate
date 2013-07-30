Warden::Manager.after_authentication do |user, warden, opts|
  if opts[:scope] == :user
    user.activities.track_sign_in warden.request.remote_ip || user.last_sign_in_ip
  end
end

Warden::Manager.before_logout do |user, _, opts|
  if opts[:scope] == :user
    user.activities.track_sign_out if user
  end
end