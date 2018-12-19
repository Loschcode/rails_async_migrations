# locks any class methods depending on a configuration list
# this allow us to ignore migration without making
# a parallel pipeline system
module RailsAsyncMigrations
  module Migration
    class Lock
      attr_reader :resource_class, :method_name

      def initialize(resource_class, method_name)
        @resource_class = resource_class
        @method_name = method_name
      end

      def perform
        return false unless locked_method?
        return false if unlocked?

        preserve_method_logics

        suspend_lock do
          overwrite_method
        end
      end

      def suspend_lock(&block)
        unlock
        yield if block_given?
        lock
      end

      private

      def unlocked?
        locked == false
      end

      def clone_method_name
        "async_#{method_name}"
      end

      def preserve_method_logics
        resource_class.define_method(clone_method_name, &captured_method)
      end

      def captured_method
        resource_class.new.method(method_name).clone
      end

      def overwrite_method
        resource_class.define_method(method_name, &overwrite_closure)
      end

      def overwrite_closure
        proc do
          Overwrite.new(self, __method__).perform
        end
      end

      def lockable?
        unlocked? && locked_method?
      end

      def locked_method?
        RailsAsyncMigrations.config.locked_methods.include? method_name
      end

      def lock
        self.locked = true
      end

      def unlock
        self.locked = false
      end

      def locked=(value)
        resource_class.instance_variable_set(:@locked, value)
      end

      def locked
        resource_class.instance_variable_get(:@locked)
      end
    end
  end
end
