require 'active_support'
require 'active_record'

begin
  require 'sidekiq'
  require 'rails_async_migrations/workers/sidekiq/check_queue_worker'
  require 'rails_async_migrations/workers/sidekiq/fire_migration_worker'
rescue LoadError
end

require 'rails_async_migrations/connection/active_record'
require 'rails_async_migrations/config'
require 'rails_async_migrations/migration'
require 'rails_async_migrations/class_mutators'
require 'rails_async_migrations/instance_mutators'
require 'rails_async_migrations/tracer'
require 'rails_async_migrations/version'
require 'rails_async_migrations/railtie' if defined?(Rails)
require 'rails_async_migrations/models/async_schema_migration'
require 'rails_async_migrations/workers'

module RailsAsyncMigrations
  class Error < StandardError; end

  class << self
    def config
      @config ||= Config.new
      if block_given?
        yield @config
      else
        @config
      end
    end

    def reset
      @config = Config.new
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Migration.extend RailsAsyncMigrations::ClassMutators
  ActiveRecord::Migration.include RailsAsyncMigrations::InstanceMutators
end
