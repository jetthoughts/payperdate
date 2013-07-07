module HstoreValidator
  def hstore_validates_presence_of(*args, &block)
    validate do
      if !block || block && yield(self)
        args.each do |arg|
          value = send arg.split('.')[0]
          arg.split('.')[1..-1].each do |element|
            value = value[element] unless value.nil?
          end
          if value.nil? || !value || value == ''
            errors["#{arg}"] << 'Field is required'
          end
        end
      end
    end
  end
end

module HstoreProperties
  def method_missing(m, *args, &block)
    hstore_property m || super
  end

  private

  def parse_hstore_property(string)
    # example of matched string: 'general_info[:address_line_1]'
    /^([a-z0-9_]*)\[([a-z0-9_]*)\]$/.match string
  end

  def hstore_property(string)
    property = parse_hstore_property(string)
    property && send(property[1]) && send(property[1])[property[2]]
  end
end
