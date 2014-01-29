module ActiveSerializer::Serializable

  def serialize(*objects)
    serialization_options = self.class_variable_get(:@@serialization_options)
    serialization_rules   = self.class_variable_get(:@@serialization_rules)
    ActiveSerializer::Support::ArgsValidator.not_nil!(serialization_rules, :serialization_rules)

    serialized_data = run_serialization(objects, serialization_rules, serialization_options)

    if serialization_options[:no_root_node]
      serialized_data.first[1]
    else
      serialized_data
    end
  end

  def serialize_all(collection, options = {})
    collection.map do |object|
      serialize(object, options)
    end
  end

  def serialization_rules(options = {}, &block)
    self.class_variable_set(:@@serialization_options, options)
    ActiveSerializer::SerializationRulesValidator.validate!(&block)
    self.class_variable_set(:@@serialization_rules, block)
  end

  private

  def run_serialization(objects, serialization_rules, serialization_options)
    raise NotImplementedError, "should be implemented in derived class"
  end

end
