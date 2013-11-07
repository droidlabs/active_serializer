module ActiveSerializer::Serializable
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize(*objects)
      first_object = objects.first
      serialization_rules = self.class_variable_get(:@@serialization_rules)

      serializer = ActiveSerializer::Serializer.new(first_object)
      instance_exec do
        serializer.instance_exec(*objects, &serialization_rules)
      end
      serializer.attrs
    end

    def serialization_rules(&block)
      self.class_variable_set(:@@serialization_rules, block)
    end
  end

end
