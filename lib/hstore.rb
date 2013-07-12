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

module HstoreSearch
  def search_hstore(query)
    wheres = []
    arguments = []
    query.each do |key, value|
      predicate = key.split('_')[-1]
      if predicate == 'hstore'
        hstore = key.split('_')[0...-1].join('_')
        rules = {}
        value.each do |key, params|
          predicate = key.split('_')[-1]
          field = key.split('_')[0...-1].join('_')
          value = params
          if params.is_a? Hash
            value = params.keys
          end
          # me = me.send "search_#{predicate}", hstore, field, value
          unless value.nil? || value.empty?
            where_call = send "search_#{predicate}", hstore, field, value
            wheres.push where_call[:where]
            arguments += where_call[:params]
          end
        end
      else # delegate it to ransack's :search
        # me = me.search key => value
      end
    end
    where wheres.join(' and '), *arguments
  end

  private

    def search_cont(hstore, key, value)
      { where: " lower(#{hstore} -> ?) like ? ", params: [key, "%#{value.downcase}%"] }
    end

    def search_gteg(hstore, key, value)
      { where: " #{hstore} -> ? != '' and cast(#{hstore} -> ? as integer) >= ? ", params: [key, key, value.to_i] }
    end

    def search_lteg(hstore, key, value)
      { where: " #{hstore} -> ? != '' and cast(#{hstore} -> ? as integer) <= ? ", params: [key, key, value.to_i] }
    end

    def search_in(hstore, key, values)
      { where: " #{hstore} -> ? in (?) ", params: [key, values] }
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
