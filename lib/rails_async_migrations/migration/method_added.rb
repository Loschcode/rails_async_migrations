# any method added within the synchronous migration
# with asynchronous directive will trigger this class
module RailsAsyncMigrations
  module Migration
    class MethodAdded
      attr_reader :resource_class, :method_name

      def initialize(resource_class, method_name)
        @resource_class = resource_class
        @method_name = method_name
      end

      def perform
        lock_and_overwrite
      end

      private

      def lock_and_overwrite
        Lock.new(resource_class, method_name).perform
      end
    end
  end
end