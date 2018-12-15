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
        Lock.new(resource_class, method_name,
          overwrite_with: overwrite_closure
        ).perform
      end

      # TODO: check that name (closure) if it matches concept exactly
      def overwrite_closure
        proc do
          Overwrite.new(self, __method__).perform
        end
      end
    end
  end
end