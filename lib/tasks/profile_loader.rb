class ProfileLoader
  def self.create_user(name)
    user = User.create! nickname:     name.split(' ').first.downcase, # => john
                     name:         name,
                     email:        "#{name.gsub(' ', '.').downcase}@example.com", # => john.smith@example.com
                     password:     'welcome',
                     confirmed_at: Time.current
    puts user.email
    user
  end

  def self.load(path_to_data_file)
    config = YAML::load_file path_to_data_file
    loaded_users = {}
    config.each do |user|
      u = create_user(user['name'])
      u.profile.update!(user['profile'])
      loaded_users[u.nickname] = u
    end
    loaded_users
  end
end