require 'rails_async_migrations/migration/lock'
require 'rails_async_migrations/migration/overwrite'
require 'rails_async_migrations/migration/method_added'

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
