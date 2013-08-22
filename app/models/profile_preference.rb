class ProfilePreference < ActiveRecord::Base
  has_one :profile

  def get_attributes
    column_names = ProfilePreference.column_names - ['id', 'created_at', 'updated_at']
    attributes   = { }
    column_names.each { |name| attributes[name.to_sym] = send(name.to_sym) }
    attributes
  end
end
