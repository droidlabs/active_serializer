require 'active_serializer/serializer'

module ActiveSerializer::Serializable
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize(*objects)
      first_object = objects.first
      serialization_options = self.class_variable_get(:@@serialization_options)
      serialization_rules   = self.class_variable_get(:@@serialization_rules)

      serializer = ActiveSerializer::Serializer.new(first_object)
      instance_exec do
        serializer.instance_exec(*objects, &serialization_rules)
      end
      if serialization_options[:no_root_node]
        serializer.attrs.first[1]
      else
        serializer.attrs
      end
    end

    def serialization_rules(options = {}, &block)
      self.class_variable_set(:@@serialization_options, options)
      self.class_variable_set(:@@serialization_rules, block)
    end
  end

end
