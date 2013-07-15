namespace :validate do
  desc 'Validate Photos for Nudity'
  task nudity: :environment do
    Photo.validate_nudity!
  end
end
