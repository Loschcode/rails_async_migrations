require 'active_support'
require 'rails_async_migrations/configuration'
require 'rails_async_migrations/locker'
require 'rails_async_migrations/migration'
require 'rails_async_migrations/version'
# require 'rails_async_migrations/models/async_schema_migration'

module RailsAsyncMigrations
  class Error < StandardError; end
  # Your code goes here...
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Migration.prepend(RailsAsyncMigrations::Migration)
end

module RailsAsyncMigrations
  # METHODS_MAP = [:async]

  class << self
    #   def method_missing(method, *args)
    #     unless METHODS_MAP.include?(method)
    #       raise Error, "Invalid action. Please use the methods available (#{METHODS_MAP.join(', ')})"
    #     end
    #     Request.const_get(method.capitalize).new(*args)
    #   end

    def configuration
      @configuration ||= Configuration.new
      if block_given?
        yield @configuration
      else
        @configuration
      end
    end

    alias_method :config, :configuration

    def reset
      @configuration = Configuration.new
    end
  end
end