require 'tasks/profile_loader'

desc 'setups up db and data'
task setup: :environment do
  raise 'do not run this task in production' if Rails.env.production?

  if Rails.env.development?
    Rake::Task['db:reset'].invoke
    Rake::Task['setup_sample_data'].invoke
  end
end

desc 'Setup sample data'
task setup_sample_data: :environment do
  raise 'do not run this task in production' if Rails.env.production?

  puts 'Cleaning delayed jobs..'
  Delayed::Job.delete_all

  puts 'Cleaning users..'
  User.delete_all
  puts 'Cleaning profiles'
  Profile.delete_all
  puts 'Cleaning admin users..'
  AdminUser.delete_all
  puts 'Cleaning authentitications..'
  Authentitication.delete_all
  puts 'Cleaning albums..'
  Album.delete_all
  puts 'Cleaning photos..'
  Photo.delete_all
  puts 'Cleaning wink templates...'
  WinkTemplate.delete_all
  puts 'Cleaning winks...'
  Wink.delete_all
  puts 'Cleaning gift templates...'
  GiftTemplate.delete_all
  puts 'Cleaning gifts...'
  Gift.delete_all
  puts 'Cleaning member reports...'
  MemberReport.delete_all
  puts 'Cleaning messages...'
  Message.delete_all
  puts 'Cleaning credits packages...'
  CreditsPackage.delete_all

  puts 'Setting up master admin..'

  AdminUser.create email:                 'admin@example.com',
                   password:              'welcome',
                   password_confirmation: 'welcome',
                   master:                true

  %w(kiss wink hug hello).each do |wink_name|
    WinkTemplate.create name: wink_name, image: File.open(Rails.root.join('db', 'sample_data', 'wink_templates', "#{wink_name}.gif"))
  end

  %w(camomile rose roses).each do |gift_name|
    GiftTemplate.create name: gift_name, image: File.open(Rails.root.join('db', 'sample_data', 'gift_templates', "#{gift_name}.jpg"))
  end

  credits_packages = [
    {price: 49,  credits: 100,  description: "Package #1" },
    {price: 149, credits: 500,  description: "Package #2" },
    {price: 249, credits: 1000, description: "Package #3"}
  ]

  credits_packages.each do |package|
    CreditsPackage.create package
  end


  puts 'Setting up users..'

  create_users

  User.first.gifts.create gift_template: GiftTemplate.first, user: User.last

  puts 'setup_sample_data done'
end


def create_users
  ProfileLoader.load 'config/sample_data.yml'
end

