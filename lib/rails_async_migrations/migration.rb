require 'rails_async_migrations/locker/lock'
require 'rails_async_migrations/locker/overwrite'
require 'rails_async_migrations/locker/method_added'

# when included this class is the gateway
# to the method locking system
module RailsAsyncMigrations
  module Migration
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def method_added(name)
        MethodAdded.new(self, name).perform
      end
    end
  end
end
