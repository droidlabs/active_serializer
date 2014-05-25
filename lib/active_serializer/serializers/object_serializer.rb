class ActiveSerializer::Serializers::ObjectSerializer
  attr_reader :attrs

  def initialize(object, options = {})
    @object, @options = object, options
    @attrs = {}
  end

  def serialize_collection(name, objects, klass, *args)
    raise ArgumentError, "You should provide serializer klass" if !klass
    self.attrs[name] = []
    objects.each do |object|
     self.attrs[name] << klass.serialize(object, *args)
    end
  end

  def serialize_entity(name, object, klass, *args)
    raise ArgumentError, "You should provide serializer klass" if !klass
    self.attrs[name] = klass.serialize(object, *args)
  end

  def namespace(name, &block)
    serializer = self.class.new(@object, @options)
    serializer.instance_exec(@object, &block)
    self.attrs[name] = serializer.attrs
  end

  def resource(name, object = nil, &block)
    raise "You should set name for resource" unless name
    raise "You should specify object" if @object.nil? && object.nil?
    nested_name = name
    nested_object = object || @object.send(nested_name)
    unless nested_object
      self.attrs[nested_name] = {}
    else
      if block_given?
        self.attrs[nested_name] = nested_resource(nested_name, nested_object, @options, &block)
      elsif nested_object.respond_to?(:to_hash)
        self.attrs[nested_name] = nested_object.to_hash
      elsif nested_object.is_a?(String)
        self.attrs[nested_name] = nested_object
      else
        raise "You should specify block or declare 'to_hash' method"
      end
    end
  end

  def resources(name, objects = nil, &block)
    raise "You should specify object" if @object.nil? && objects.nil?
    objects = objects.flatten unless objects.nil?
    nested_objects = objects || @object.send(name.to_s)
    unless nested_objects
      self.attrs[name] = []
    else
      self.attrs[name] = (nested_objects || []).inject([]) do |result, obj|
        resource = nested_resource(name, obj, @options, &block)
        resource.empty? ? result : (result << resource)
      end
    end
  end

  def attributes(*attrs, &block)
    if !attrs.last.is_a?(Symbol) && !attrs.last.is_a?(String)
      object = attrs.last
      attrs.delete(attrs.last)
    end
    if !@object && !object
      raise ArgumentError, "Object was not specified"
    end

    target = object || @object
    Array.wrap(attrs).flatten.each do |attribute|
      serialize_attribute(attribute, target)
    end
  end

  def attribute(attr, val = nil, &block)
    if block_given?
      self.attrs[attr] = yield
      return
    end

    if @object.blank?
      raise ArgumentError, "Neither object was specified nor block was given"
    end
    self.attrs[attr] = val || @object.send(attr.to_s)
  end

  protected

  def serialize_attribute(attribute, target)
    self.attrs[attribute] = target.send(attribute.to_s)
  end

  def nested_resource(name, object, options, serializer_class = self.class, &block)
    return nil if !object
    serializer = serializer_class.new(object, options)
    if block_given?
      serializer.instance_exec(object, &block)
      serializer.attrs
    else
      if object.respond_to?(:to_hash)
        object.to_hash
      elsif object.is_a?(String)
        object
      end
    end
  end

end
