# takes any class methods depending on a configuration list
# this allow us to ignore migration without making
# a parallel pipeline system
module RailsAsyncMigrations
  module Migration
    class Take
      include RailsAsyncMigrations::DefineMethodIn

      attr_reader :resource_class, :method_name

      def initialize(resource_class, method_name)
        @resource_class = resource_class
        @method_name = method_name
      end

      def perform
        return false unless taken_method?
        return false if given?

        preserve_method_logics

        suspend_take do
          overwrite_method
        end
      end

      def suspend_take(&block)
        give
        yield if block_given?
        take
      end

      private

      def given?
        taken == false
      end

      def clone_method_name
        "async_#{method_name}"
      end

      def preserve_method_logics
        define_method_in(resource_class, clone_method_name, &captured_method)
      end

      def captured_method
        resource_class.new.method(method_name).clone
      end

      def overwrite_method
        define_method_in(resource_class, method_name, &overwrite_closure)
      end

      def overwrite_closure
        proc do
          Overwrite.new(self, __method__).perform
        end
      end

      def takeable?
        given? && taken_method?
      end

      def taken_method?
        RailsAsyncMigrations.config.taken_methods.include? method_name
      end

      def take
        self.taken = true
      end

      def give
        self.taken = false
      end

      def taken=(value)
        resource_class.instance_variable_set(:@taken, value)
      end

      def taken
        resource_class.instance_variable_get(:@taken)
      end
    end
  end
end
