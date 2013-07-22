task validate: 'validate:photos'

namespace :validate do
  desc 'validate all Photos'
  task photos: :environment do
    Photo.validate_images!
  end

  desc 'validate only Avatars'
  task avatars: :environment do
    Avatar.validate_images!
  end
end
