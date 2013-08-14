module SelectHelper
  @@selector_config = YAML::load File.open 'config/selector.yml'
  @@selector_generated_config = {}

  def self.selector_config
    @@selector_config
  end

  def self.generated(id)
    generate(id) unless @@selector_generated_config[id]
    @@selector_generated_config[id]
  end

  def self.generate(id)
    @@selector_generated_config[id] = {}
    @@selector_generated_config[id][:options] = generate_options(id)
    @@selector_generated_config[id][:hash] = generate_hash(id)
  end

  def self.generate_options(id)
    res = [[@@selector_config[id]['empty'], '']]
    @@selector_config[id]['items'].each do |option|
      option.each do |value, title|
        res << [title, value]
      end
    end
    res
  end

  def self.generate_hash(id)
    res = {}
    generated(id)[:options].each do |title, value|
      res[value] = title
    end
    res[''] = @@selector_config['empty']
    res
  end

  def multiselect_accessor(relation, name, select_type)
    metaclass = class << self; self; end

    define_method :"#{name}_multiselect" do
      send(relation).where name: name.to_s
    end

    define_method :"#{name}_multiselect=" do |value|
      send(relation).where(name: name.to_s).each do |select|
        select.update! checked: value.include?(select.value)
      end
    end

    after_save do
      selects[select_type].each do |item|
        unless send(relation).where(name: name.to_s, value: item[:key]).first
          send(relation).create profile_id: id, name: name.to_s,
                                value: item[:key], select_type: select_type, checked: false
        end
      end
    end
  end

  def multiselect_search(options)
    wheres = []
    params = []
    having = []
    key_param = "profile_multiselects.name||'_'||profile_multiselects.value||'_'||cast(profile_multiselects.checked as text)"
    options.each do |key, value|
      name = key.gsub /_multiselect$/, ''
      wheres << " #{key_param} in (?) "
      params << value.map { |e| "#{name}_#{e}_true" }
      having << " bool_or(profile_multiselects.name = '#{name}') "
    end
    if options.count > 0
      joins(:profile_multiselects).where(wheres.join('or'), *params)
          .group("profiles.id having #{having.join('and')}")
    else
      all
    end
  end

  def select_options(id)
    SelectHelper.generated(id)[:options]
  end

  def select_title(id, value)
    SelectHelper.generated(id)[:hash][value]
  end

  def select_config
    SelectHelper.selector_config
  end

  def selects
    res = select_config.clone
    res.delete 'empty'
    res.map do |key, value|
      res[key] = value['items'].map { |x| { key: x.first[0], title: x.first[1] } }
    end
    res
  end

  def self.selects
    res = select_config.clone
    res.delete 'empty'
    res.map do |key, value|
      res[key] = value['items'].map { |x| { key: x.first[0], title: x.first[1] } }
    end
    res
  end

end
