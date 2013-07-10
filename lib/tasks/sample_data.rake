desc 'setups up db and data'
task setup: :environment do
  raise 'do not run this task in production' if Rails.env.production?

  if Rails.env.development?
    Rake::Task['db:reset'].invoke
    # Rake::Task['db_reset'].invoke
    Rake::Task['setup_sample_data'].invoke
  end
end

# desc 'Custom db:reset (hstore aware)'
# task db_reset: :environment do
#   Rake::Task['db:drop'].invoke
#   Rake::Task['db:create'].invoke
#   User.connection.execute 'CREATE EXTENSION IF NOT EXISTS hstore'
#   Rake::Task['db:schema:load'].invoke
# end

desc 'Setup sample data'
task setup_sample_data: :environment do
  #raise 'do not run this task in production' if Rails.env.production?
  User.delete_all
  AdminUser.delete_all
  Authentitication.delete_all
  Album.destroy_all

  AdminUser.create!(email: 'admin@example.com', password: 'welcome', password_confirmation: 'welcome')

  create_users

  puts 'setup_sample_data done'
end


def create_users
  # create_user('John Smith') # nickname: john, email: john.smith@example.com, password: welcome
  # create_user('User User') # nickname: user, email: user.user@example.com, password: welcome
  load_profiles
end


def create_user(name)
  User.create! nickname:     name.split(' ').first.downcase, # => john
               name:         name,
               email:        "#{name.gsub(' ', '.').downcase}@example.com", # => john.smith@example.com
               password:     'welcome',
               confirmed_at: Time.current
end

def load_profiles
  config = YAML::load File::read 'config/sample_data.yml'
  config.each do |user|
    create_user(user['name']).profile.update!(user['profile'])
  end
end
