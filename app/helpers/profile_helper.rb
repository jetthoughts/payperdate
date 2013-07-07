require 'selector'

module ProfileHelper
  include SelectHelper

  def profiles_path(profile_id)
    profile_edit_path
  end

  def profile_path(*args)
    profile_edit_path
  end
end
