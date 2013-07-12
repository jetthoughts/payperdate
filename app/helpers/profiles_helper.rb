require 'selector'

module ProfilesHelper
  include SelectHelper

  def gmap_for(profile)
    t 'tools.gmap.uri', latitude: profile.latitude, longitude: profile.longitude
  end
end
