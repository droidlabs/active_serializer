module ActiveSerializer::Support::ArgsValidator
  class << self
    def is_symbol!(obj, obj_name)
      unless obj.is_a?(Symbol)
        raise ArgumentError, "#{obj_name} should be a Symbol"
      end
    end

    def is_class!(obj, obj_name)
      unless obj.is_a?(Class)
        raise ArgumentError, "#{obj_name} should be a Class"
      end
    end

    def is_array!(obj, obj_name)
      unless obj.is_a?(Array)
        raise ArgumentError, "#{obj_name} should be an Array"
      end
    end

    def is_hash!(obj, obj_name)
      unless obj.is_a?(Hash)
        raise ArgumentError, "#{obj_name} should be a Hash"
      end
    end

    def has_key!(hash, key)
      unless hash.has_key?(key)
        raise ArgumentError, "#{hash} should has #{key} key"
      end
    end

    def is_array_of_symbols!(array, obj_name)
      is_array!(array, obj_name)
      unless array.all? { |item| item.is_a?(Symbol) }
        raise ArgumentError, "#{obj_name} elements should be a symbols"
      end
    end

    def block_given!(block, obj_name)
      unless block
        raise ArgumentError, "Block should be given to #{obj_name}"
      end
    end

    def not_nil!(obj, obj_name)
      unless obj
        raise ArgumentError, "#{obj_name} can not be nil"
      end
    end
  end
end
