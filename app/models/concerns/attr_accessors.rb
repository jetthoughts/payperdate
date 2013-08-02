module AttrAccessors
  extend ActiveSupport::Concern

  module ClassMethods
    def integer_attr_accessor(*names)
      names.each do |name|
        define_method name do 
          instance_variable_get("@#{name}")
        end

        define_method "#{name}=" do |value|
          instance_variable_set("@#{name}", value.blank? ? nil : ActiveRecord::ConnectionAdapters::Column.value_to_integer(value))
        end
      end
    end

    def boolean_attr_accessor(*names)
      names.each do |name|
        define_method name do 
          instance_variable_get("@#{name}")
        end

        define_method "#{name}=" do |value|
          instance_variable_set("@#{name}", value.blank? ? nil : ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value))
        end
      end
    end
  end

end
