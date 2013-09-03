require 'selector'

module ProfilesHelper
  include SelectHelper

  def gmap_for(profile)
    t 'tools.gmap.uri', latitude: profile.latitude, longitude: profile.longitude
  end

  # for active admin table views
  def profile_panel(name, opts)
    name = name.to_s
    panel name.humanize, id: name do
      render "admin/profile/#{name}", opts
    end
  end

  def profile_panels(*names, opts)
    names.each do |name|
      profile_panel name, opts
    end
  end

  def changed_field?(profile, field_name)
    'profile-field-changed' if profile[field_name] != profile.auto_user.published_profile[field_name]
  end

  def highlight_obscenity(value)
    highlight(value, Obscenity.offensive(value))
  end
end
