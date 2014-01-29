require 'active_serializer/serializers/object_serializer'
require 'active_serializer/serializers/restrict_fields_object_serializer'

module ActiveSerializer::SerializableObject
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize(*objects)
      first_object = objects.first
      options = objects.last.is_a?(Hash) ? objects.last : {}

      serialization_options = self.class_variable_get(:@@serialization_options)
      serialization_rules   = self.class_variable_get(:@@serialization_rules)

      if options[:serializable_fields]
        serializer = ActiveSerializer::Serializers::RestrictFieldsObjectSerializer.new(first_object, options)
      else
        serializer = ActiveSerializer::Serializers::ObjectSerializer.new(first_object, options)
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

    private
  end

end
