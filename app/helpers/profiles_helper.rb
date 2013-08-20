require 'selector'

module ProfilesHelper
  include SelectHelper

  def gmap_for(profile)
    t 'tools.gmap.uri', latitude: profile.latitude, longitude: profile.longitude
  end

  # for active admin table views
  def profile_panel(name)
    name = name.to_s
    panel name.humanize, id: name do
      render "admin/profile/#{name}"
    end
  end

  def profile_panels(*names)
    names.each do |name|
      profile_panel name
    end
  end
end
