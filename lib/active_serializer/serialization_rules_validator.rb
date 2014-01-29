class ActiveSerializer::SerializationRulesValidator
  private :initialize

  def self.validate!(&rules)
    validator = self.new
    validator.instance_exec(&rules)
  end

  def attribute(name, value = nil, &block)
    ActiveSerializer::ArgsValidator.is_symbol!(name, 'attributes')
  end

  def attributes(*attrs)
    attrs.delete_at(-1)
    ActiveSerializer::ArgsValidator.is_array_of_symbols!(attrs, 'attributes')
  end

  def namespace(name, &block)
    ActiveSerializer::ArgsValidator.is_symbol!(name, 'namespace name')
    ActiveSerializer::ArgsValidator.block_given!(block, 'namespace block')
  end

  def resource(name, object = nil, &block)
    ActiveSerializer::ArgsValidator.is_symbol!(name, 'resource name')
    ActiveSerializer::ArgsValidator.block_given!(block, 'resource block')
  end

  def resources(name, objects = nil, &block)
    ActiveSerializer::ArgsValidator.is_symbol!(name, 'resources name')
    ActiveSerializer::ArgsValidator.block_given!(block, 'resources block')
  end
end
