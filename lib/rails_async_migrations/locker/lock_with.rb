module RailsAsyncMigrations
  module Locker
    class LockWith
      attr_reader :resource_class, :name

      def initialize(resource_class, name)
        @resource_class = resource_class
        @name = name
      end

      def perform
        return false unless locked_method?
        return false if unlocked?

        # run the overwrite
        suspend_lock do
          resource_class.define_method(name, overwrite)
        end
      end

      def unlocked?
        locked == false
      end

      private

      def overwrite
        proc do
          puts 'yo!'
        end
      end

      def suspend_lock(&block)
        unlock
        yield if block_given?
        lock
      end

      def lockable?
        unlocked? && locked_method?
      end

      def locked_method?
        RailsAsyncMigrations.config.locked_methods.include? name
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