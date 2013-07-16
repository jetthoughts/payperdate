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
  AdminUser.delete_all
  Authentitication.delete_all
  Album.destroy_all

  puts 'Setting up admin'

  # magic 'create! not passed values to model, perhaps problem with hstore helper' do
  a = AdminUser.new
  2.times do
    a.update_attributes email: 'admin@example.com', password: 'welcome',
                        password_confirmation: 'welcome', master: true
  end
  # end

  puts 'Setting up users'

  create_users

  puts 'setup_sample_data done'
end


def create_users
  load_profiles
end


def create_user(name)
  u = User.create! nickname:     name.split(' ').first.downcase, # => john
                   name:         name,
                   email:        "#{name.gsub(' ', '.').downcase}@example.com", # => john.smith@example.com
                   password:     'welcome',
                   confirmed_at: Time.current
  puts u.email
  u
end

def load_profiles
  config = YAML::load_file 'config/sample_data.yml'
  config.each do |user|
    create_user(user['name']).profile.update!(user['profile'])
  end
end
