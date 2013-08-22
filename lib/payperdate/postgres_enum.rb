module ::ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def create_enum_type(name, values, options = {})
      end
      def drop_enum_type(name, values, options = {})
      end
    end
    class PostgreSQLAdapter
      def create_enum_type(name, values, options = {})
        values_query = values.map { |v| "'#{v}'" }
        query = "CREATE TYPE enum_#{name} AS ENUM (#{values_query.join(', ')});"
        ActiveRecord::Base.connection.execute query
        enum_types = YAML::load_file 'config/enum_types.yml'
        enum_types["#{name}"] = values
        File.open('config/enum_types.yml', 'w') { |f| f.write(enum_types.to_yaml) }
        #load_enum_type(name, values)
      end
      def drop_enum_type(name, values = [], options = {})
        query = "DROP TYPE enum_#{name};"
        ActiveRecord::Base.connection.execute query
        enum_types = YAML::load_file 'config/enum_types.yml'
        enum_types = enum_types.slice! "#{name}"
        File.open('config/enum_types.yml', 'w') { |f| f.write(enum_types.to_yaml) }
      end
    end
  end
end

def load_enum_type(name, values)
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.alias_type "enum_#{name}", 'string'
  ::ActiveRecord::ConnectionAdapters::PostgreSQLColumn::Cast.class_eval do
    unless method_defined? :"string_to_#{name}"
      define_method :"string_to_#{name}" do |string|
        "#{string}::enum_#{name}"
      end
    end
  end
  ::ActiveRecord::ConnectionAdapters::Column.class_eval do
    unless method_defined? :"simplified_type_with_enum_#{name}"
      define_method "simplified_type_with_enum_#{name}" do |field_type|
        if field_type == "enum_#{name}"
          field_type.to_sym
        else
          send("simplified_type_without_enum_#{name}", field_type)
        end
      end
      alias_method_chain :simplified_type, :"enum_#{name}"
    end
  end
  ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::TableDefinition.class_eval do
    unless method_defined? :"enum_#{name}"
      define_method "enum_#{name}" do |column_name, *args|
        column column_name, :"enum_#{name}", *args
      end
    end
  end
end

def reload_enums
  YAML::load_file 'config/enum_types.yml'
end

NATIVE_DATABASE_TYPES = {
  primary_key: "serial primary key",
  string:      { name: "character varying", limit: 255 },
  text:        { name: "text" },
  integer:     { name: "integer" },
  float:       { name: "float" },
  decimal:     { name: "decimal" },
  datetime:    { name: "timestamp" },
  timestamp:   { name: "timestamp" },
  time:        { name: "time" },
  date:        { name: "date" },
  daterange:   { name: "daterange" },
  numrange:    { name: "numrange" },
  tsrange:     { name: "tsrange" },
  tstzrange:   { name: "tstzrange" },
  int4range:   { name: "int4range" },
  int8range:   { name: "int8range" },
  binary:      { name: "bytea" },
  boolean:     { name: "boolean" },
  xml:         { name: "xml" },
  tsvector:    { name: "tsvector" },
  hstore:      { name: "hstore" },
  inet:        { name: "inet" },
  cidr:        { name: "cidr" },
  macaddr:     { name: "macaddr" },
  uuid:        { name: "uuid" },
  json:        { name: "json" },
  ltree:       { name: "ltree" }
}

def load_enum_types_and_hack_active_record
  puts 'LOADING ENUM TYPES'
  enum_types = YAML::load_file 'config/enum_types.yml'
  extended_data_types = {}
  enum_types.each do |name, values|
    extended_data_types[:"enum_#{name}"] = { name: "enum_#{name}" }
    load_enum_type(name, values)
  end
  ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
    define_method :native_database_types do
      res = NATIVE_DATABASE_TYPES
      res.merge! extended_data_types
    end
  end
end

class ::ActiveRecord::SchemaDumper
  def dump(stream)
    header(stream)
    extensions(stream)
    puts '--- ENUMS ---'
    dump_enum_types(stream)
    puts '--- TABLES ---'
    tables(stream)
    puts '--- TRAILER ---'
    trailer(stream)
    puts '--- RETURN STREAM ---'
    stream
  end

  unless method_defined? :dump_enum_types
    def dump_enum_types(stream)
      enum_types = YAML::load_file 'config/enum_types.yml'
      if enum_types.any?
        stream.puts "  # These are enum types defined in this project"
        enum_types.each do |name, values|
          stream.puts "  create_enum_type :#{name}, #{values}"
        end
        stream.puts "  load_enum_types_and_hack_active_record"
        stream.puts '  # Finished with enum types'
        stream.puts
      end
    end
  end
end

# module ::ActiveRecord
#   module ConnectionAdapters
#     class PostgreSQLColumn < Column
#       module Cast
#         def string_to_gender(string)
#           "#{string}::enum_gender"
#         end
#       end
#     end
#   end
# end

# class ::ActiveRecord::ConnectionAdapters::Column
#   private
#   def simplified_type_with_enum_gender(field_type)
#     if field_type == 'enum_gender'
#       field_type.to_sym
#     else
#       simplified_type_without_enum_gender(field_type)
#     end
#   end
#   alias_method_chain :simplified_type, :enum_gender
# end

# class ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
#   NATIVE_DATABASE_TYPES_EXTENDED = {
#     primary_key: "serial primary key",
#     string:      { name: "character varying", limit: 255 },
#     text:        { name: "text" },
#     integer:     { name: "integer" },
#     float:       { name: "float" },
#     decimal:     { name: "decimal" },
#     datetime:    { name: "timestamp" },
#     timestamp:   { name: "timestamp" },
#     time:        { name: "time" },
#     date:        { name: "date" },
#     daterange:   { name: "daterange" },
#     numrange:    { name: "numrange" },
#     tsrange:     { name: "tsrange" },
#     tstzrange:   { name: "tstzrange" },
#     int4range:   { name: "int4range" },
#     int8range:   { name: "int8range" },
#     binary:      { name: "bytea" },
#     boolean:     { name: "boolean" },
#     xml:         { name: "xml" },
#     tsvector:    { name: "tsvector" },
#     hstore:      { name: "hstore" },
#     inet:        { name: "inet" },
#     cidr:        { name: "cidr" },
#     macaddr:     { name: "macaddr" },
#     uuid:        { name: "uuid" },
#     json:        { name: "json" },
#     ltree:       { name: "ltree" },
#     # custom
#     enum_gender: { name: "enum_gender" }
#   }

#   def native_database_types
#     NATIVE_DATABASE_TYPES_EXTENDED
#   end
# end
