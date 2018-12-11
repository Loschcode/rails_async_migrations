module RailsAsyncMigrations
  module Locker
    class LockWith
      def initialize(instance, name)
        @instance = instance
        @name = name
      end

      def perform
        return false if unlocked?

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

      # TODO: put into config
      def allowed_method?
        [:change].include? name
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

      def name
        @name
      end

      def instance
        @instance
      end
    end
  end
end