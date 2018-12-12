require 'rails_async_migrations/locker/lock_with'

module RailsAsyncMigrations
  module Locker
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def method_added(name)
        lock_with self, name
      end

      private

      def lock_with(*args)
        LockWith.new(*args).perform
      end
    end
  end
end
