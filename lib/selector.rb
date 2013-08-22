module SelectHelper
  @@selector_config = YAML::load File.open 'config/selector.yml'
  @@enum_config = reload_enums
  @@selector_generated_config = {}

  def self.enum_config
    @@enum_config
  end

  def self.generated(id)
    generate(id) unless @@selector_generated_config[id]
    @@selector_generated_config[id]
  end

  def self.generate(id)
    @@selector_generated_config[id] = {}
    @@selector_generated_config[id][:options] = {}
    @@selector_generated_config[id][:options]['true'] = generate_options(id, true)
    @@selector_generated_config[id][:options]['false'] = generate_options(id, false)
    @@selector_generated_config[id][:hash] = generate_hash(id)
  end

  def self.generate_options(enum_type, no_empty)
    res = []
    @@enum_config[enum_type].each do |value|
      if "#{value}" == ':'
        value = ''
        if no_empty
          next
        end
      end
      res << [I18n.t("enums.#{enum_type}.value_#{value}"), value]
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

  def multiselect_init(relation, relations)
    metaclass = class << self; self; end
    unless method_defined? :multiselect_relation
      define_method :multiselect_relation do
        relation
      end
      metaclass.class_eval do
        define_method :multiselect_relation do
          relation
        end
      end
      define_method :multiselect_relations do
        relations
      end
      metaclass.class_eval do
        define_method :multiselect_relations do
          relations
        end
      end
    end
  end

  def multiselect_accessor(name, enum_type)
    enums = reload_enums

    define_method :"#{name}_multiselect" do
      relation = multiselect_relation
      res = []
      enums[enum_type].each do |value|
        if send(relation)[:"#{name}_is_#{value}"]
          res << value
        end
      end
      res
    end

    define_method :"#{name}_multiselect=" do |values|
      relation = multiselect_relation
      enums[enum_type].each do |value|
        if value != ':'
          send(relation)[:"#{name}_is_#{value}"] = values.include?(value.to_s)
        end
      end
      send(relation).save!
    end
  end

  def select_options(id, no_empty=true)
    SelectHelper.generated(id)[:options]["#{no_empty}"]
  end

  def select_title(id, value)
    # SelectHelper.generated(id)[:hash][value]
    I18n.t "enums.#{id}.value_#{value}"
  end

  def select_config
    SelectHelper.selector_config
  end

  def selects(no_empty=true)
    res = @@enum_config.clone
    if no_empty
      res.each do |k, v|
        v.delete ':'
        res[k] = v
      end
    end
    res
  end

  def self.selects(no_empty=true)
    res = @@enum_config.clone
    if no_empty
      res.each do |k, v|
        v.delete ':'
        res[k] = v
      end
    end
    res
  end

end
