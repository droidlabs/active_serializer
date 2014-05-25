class ActiveSerializer::Serializers::HashSerializer
  attr_reader :serialized_data

  def initialize(root_hash, options = {})
    @root_hash       = root_hash
    @options         = options
    @serialized_data = {}
  end

  def attribute(name, value = nil, &block)
    if block_given?
      value = yield
    elsif !value
      value = @root_hash[name]
    end
    set_value(name, value)
  end

  def serialize_collection(name, objects, klass, *args)
    raise ArgumentError, "You should provide serializer klass" if !klass
    self.serialized_data[name] = []
    objects.each do |object|
     self.serialized_data[name] << klass.serialize(object, *args)
    end
  end

  def serialize_entity(name, object, klass, *args)
    raise ArgumentError, "You should provide serializer klass" if !klass
    self.serialized_data[name] = klass.serialize(object, *args)
  end

  def attributes(*serialized_data, &block)
    if !serialized_data.last.is_a?(Symbol)
      source_hash = serialized_data.delete_at(-1)
    else
      source_hash = @root_hash
    end

    serialized_data.each do |attr_name|
      set_value(attr_name, source_hash[attr_name])
    end
  end

  def namespace(name, &block)
    serializer = self.class.new(@root_hash, @options)
    serializer.instance_exec(@root_hash, &block)
    set_value(name, serializer.serialized_data)
  end

  def resource(name, source_hash = nil, &block)
    source_hash ||= @root_hash[name]
    set_value(name, serialize_resource(source_hash, &block))
  end

  def resources(name, source_hashes = nil, &block)
    source_hashes ||= @root_hash[name]

    self.serialized_data[name] = (source_hashes || []).inject([]) do |result, source_hash|
      data = serialize_resource(source_hash, &block)
      data.empty? ? result : (result << data)
    end
  end

  protected

  def serialize_resource(source_hash, &block)
    return nil unless source_hash
    serializer = self.class.new(source_hash, @options)
    serializer.instance_exec(source_hash, &block)
    serializer.serialized_data
  end

  def set_value(name, value)
    self.serialized_data[name] = value
  end

end
