module ActiveSerializer
  module Support
    class FakeObject
      def method_missing(method_name, *args, &block)
        self.class.new
      end
    end
  end
end
