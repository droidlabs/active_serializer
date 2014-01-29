class ActiveSerializer::Serializers::IgnoreBlankHashSerializer < ActiveSerializer::Serializers::HashSerializer

  protected

  def set_value(name, value)
    self.serialized_data[name] = value unless value.nil?
  end

end
