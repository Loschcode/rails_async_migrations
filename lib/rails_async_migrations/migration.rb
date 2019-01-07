require 'rails_async_migrations/migration/check_queue'
require 'rails_async_migrations/migration/fire_migration'
require 'rails_async_migrations/migration/take'
require 'rails_async_migrations/migration/method_added'
require 'rails_async_migrations/migration/overwrite'
require 'rails_async_migrations/migration/run'
require 'rails_async_migrations/migration/give'

# when included this class is the gateway
# to the method takeing system
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
