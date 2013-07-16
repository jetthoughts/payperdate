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
end
