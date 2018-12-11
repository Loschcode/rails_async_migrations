module RailsAsyncMigrations
  module Locker
    class LockWith
      attr_reader :instance, :name

      def initialize(instance, name)
        @instance = instance
        @name = name
      end

      def perform
        return false if lockable?

        suspend_lock do
          instance.define_method(name, overwrite)
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
        unlocked? && allowed_method?
      end

      def allowed_method?
        RailsAsyncMigrations.config.locked_methods.include? name
      end

      def lock
        self.locked = true
      end

      def unlock
        self.locked = false
      end

      def locked=(value)
        instance.instance_variable_set(:@locked, value)
      end

      def locked
        instance.instance_variable_get(:@locked)
      end
    end
  end
end