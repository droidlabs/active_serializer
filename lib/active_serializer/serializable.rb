require 'active_serializer/serializers'
require 'active_serializer/serializers/standard_serializer'
require 'active_serializer/serializers/restrict_fields_serializer'

module ActiveSerializer::Serializable
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize(*objects)
      first_object = objects.first
      options = objects.last.is_a?(Hash) ? objects.last : {}

      serialization_options = self.class_variable_get(:@@serialization_options)
      serialization_rules   = self.class_variable_get(:@@serialization_rules)

      if options[:serializable_fields]
        serializer = ActiveSerializer::Serializers::RestrictFieldsSerializer.new(first_object, options)
      else
        serializer = ActiveSerializer::Serializers::StandardSerializer.new(first_object, options)
      end
      instance_exec do
        serializer.instance_exec(*objects, &serialization_rules)
      end
      if serialization_options[:no_root_node]
        serializer.attrs.first[1]
      else
        serializer.attrs
      end
    end

    def serialize_all(collection, options = {})
      collection.map do |object|
        serialize(object, options)
      end
    end

    def serialization_rules(options = {}, &block)
      self.class_variable_set(:@@serialization_options, options)
      self.class_variable_set(:@@serialization_rules, block)
    end
  end

end
