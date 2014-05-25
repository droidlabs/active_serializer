class ActiveSerializer::SerializationRulesValidator
  private :initialize

  def self.validate!(&rules)
    fake_objects = rules.arity.times.map do
      ActiveSerializer::Support::FakeObject.new
    end
    validator = self.new
    validator.instance_exec(*fake_objects, &rules)
  end

  def attribute(name, value = nil, &block)
    ActiveSerializer::Support::ArgsValidator.is_symbol!(name, 'attributes')
  end

  def serialize_collection(*attrs)
    key    = attrs[0]
    object = attrs[1]
    klass  = attrs[2]
    ActiveSerializer::Support::ArgsValidator.is_symbol!(key, 'collection name')
    ActiveSerializer::Support::ArgsValidator.is_class!(klass, 'serializer class')
  end

  def serialize_entity(*attrs)
    key    = attrs[0]
    klass  = attrs[2]
    ActiveSerializer::Support::ArgsValidator.is_symbol!(key, 'collection name')
    ActiveSerializer::Support::ArgsValidator.is_class!(klass, 'serializer class')
  end

  def attributes(*attrs)
    attrs.delete_at(-1)
    ActiveSerializer::Support::ArgsValidator.is_array_of_symbols!(attrs, 'attributes')
  end

  def namespace(name, &block)
    ActiveSerializer::Support::ArgsValidator.is_symbol!(name, 'namespace name')
    ActiveSerializer::Support::ArgsValidator.block_given!(block, 'namespace block')
  end

  def resource(name, object = nil, &block)
    ActiveSerializer::Support::ArgsValidator.is_symbol!(name, 'resource name')
    ActiveSerializer::Support::ArgsValidator.block_given!(block, 'resource block')
  end

  def resources(name, objects = nil, &block)
    ActiveSerializer::Support::ArgsValidator.is_symbol!(name, 'resources name')
    ActiveSerializer::Support::ArgsValidator.block_given!(block, 'resources block')
  end
end
