require 'rails_async_migrations/locker/lock'
require 'rails_async_migrations/locker/overwrite'

module RailsAsyncMigrations
  module Locker
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def method_added(name)
        lock self, name
      end

      private

      def lock(*args)
        Lock.new(*args).perform
      end
    end
  end
end
