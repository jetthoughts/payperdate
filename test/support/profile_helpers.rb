module Payperdate::TestHelpers
  def initial_setup
    User.all.each do |u|
      u.profile || u.create_profile
      u.published_profile || u.create_published_profile
      u.save!
      u.profile.approve! if u.profile.reviewed?
    end
  end
end
