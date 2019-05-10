module RailsAsyncMigrations
  module Migration
    class Give
      include RailsAsyncMigrations::DefineMethodIn
      
      attr_reader :resource_class, :method_name

      def initialize(resource_class, method_name)
        @resource_class = resource_class
        @method_name = method_name
      end

      def perform
        restore_original_method
      end

      private

      def restore_original_method
        if valid?
          Take.new(resource_class, method_name).suspend_take do
            define_method_in(resource_class, method_name, &method_clone)
          end
        end
      end

      def valid?
        temporary_instance.respond_to? clone_method_name
      end

      def clone_method_name
        "async_#{method_name}"
      end

      def method_clone
        temporary_instance.method(clone_method_name).clone
      end

      def temporary_instance
        @temporary_instance ||= resource_class.new
      end
    end
  end
end