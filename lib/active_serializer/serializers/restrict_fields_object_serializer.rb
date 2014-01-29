class ActiveSerializer::Serializers::RestrictFieldsObjectSerializer < ActiveSerializer::Serializers::ObjectSerializer
  def initialize(object, options)
    raise ArgumentError, 'serializable_fields should be specified' unless options[:serializable_fields]
    super
    @serializable_fields = options[:serializable_fields].keys
  end

  def resource(name, object = nil, &block)
    super if @serializable_fields.include?(name)
  end

  def resources(name, objects = nil, &block)
    super if @serializable_fields.include?(name)
  end

  def attribute(name, val = nil, &block)
    super if @serializable_fields.include?(name)
  end

  protected

  def serialize_attribute(attribute, target)
    super if @serializable_fields.include?(attribute)
  end

  def nested_resource(name, object, root_options, serializer_class = self.class, &block)
    options = root_options.dup
    serializable_fields = root_options[:serializable_fields][name]
    if !serializable_fields
      return
    elsif serializable_fields == true
      super(name, object, options, ActiveSerializer::Serializers::ObjectSerializer, &block)
    elsif serializable_fields.is_a?(Hash)
      options[:serializable_fields] = serializable_fields
      super(name, object, options, &block)
    else
      raise ArgumentError, "serializable_fields' values should be boolean or hash"
    end
  end
end
