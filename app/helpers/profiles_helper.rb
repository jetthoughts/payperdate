require 'selector'

module ProfilesHelper
  include SelectHelper

  def gmap_for(profile)
    t 'tools.gmap.uri', latitude: profile.latitude, longitude: profile.longitude
  end

  # for active admin table views
  def select_row(param, type)
    row param do
      select_title(type, profile.send(param))
    end
  end

  def row_with_profanity(param)
    row param do
      value = profile.send(param)
      words = Obscenity.offensive(value)
      highlight(value, words)
    end
  end
end
