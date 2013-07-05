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
  #raise 'do not run this task in production' if Rails.env.production?
  User.delete_all
  Authentitication.delete_all
  create_users
  puts 'setup_sample_data done'
end


def create_users
  User.create! nickname: 'john', name: 'John Smith', email: 'john.smith@example.com', password: 'welcome', confirmed_at: Time.current
end
