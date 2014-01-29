module ActiveSerializer
  module Support
    class FakeObject
      def method_missing(method_name, *args, &block)
        true
      end
    end
  end
end
