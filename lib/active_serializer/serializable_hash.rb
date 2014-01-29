require 'active_serializer/serializers/hash_serializer'
require 'active_serializer/serializers/ignore_blank_hash_serializer'

module ActiveSerializer::SerializableHash
  extend ActiveSupport::Concern

  module ClassMethods
    include ActiveSerializer::Serializable

    private

    def run_serialization(objects, serialization_rules, serialization_options)
      if serialization_options[:ignore_blank]
        serializer = ActiveSerializer::Serializers::IgnoreBlankHashSerializer.new(objects.first, serialization_options)
      else
        serializer = ActiveSerializer::Serializers::HashSerializer.new(objects.first, serialization_options)
      end
      instance_exec do
        serializer.instance_exec(*objects, &serialization_rules)
      end
      serializer.serialized_data
    end
  end

end
