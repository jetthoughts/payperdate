require 'hstore'

class Search
  include HstoreProperties

  attr_accessor :general_info_hstore, :personal_preferences_hstore,
                :date_preferences_hstore, :optional_info_hstore,
                :location, :max_distance

  def initialize(search)
    @general_info_hstore = search['general_info_hstore'] || {}
    @personal_preferences_hstore = search['personal_preferences_hstore'] || {}
    @date_preferences_hstore = search['date_preferences_hstore'] || {}
    @optional_info_hstore = search['optional_info_hstore'] || {}
    @location = search['location']
    @max_distance = search['max_distance']
  end

  def checked?(section, key, value)
    select = send("#{section}_hstore")["#{key}_in"]
    select && select[value] == 'on'
  end

  def query
    {
      'general_info_hstore' => general_info_hstore,
      'personal_preferences_hstore' => personal_preferences_hstore,
      'date_preferences_hstore' => date_preferences_hstore,
      'optional_info_hstore' => optional_info_hstore
    }
  end
end
