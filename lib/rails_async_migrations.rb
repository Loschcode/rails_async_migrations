require 'active_support'
require 'rails_async_migrations/config'
require 'rails_async_migrations/migration'
require 'rails_async_migrations/mutators'
require 'rails_async_migrations/tracer'
require 'rails_async_migrations/version'
require 'rails_async_migrations/models/async_schema_migration'

module RailsAsyncMigrations
  class Error < StandardError; end
  # METHODS_MAP = [:async]

  class << self
    #   def method_missing(method, *args)
    #     unless METHODS_MAP.include?(method)
    #       raise Error, "Invalid action. Please use the methods available (#{METHODS_MAP.join(', ')})"
    #     end
    #     Request.const_get(method.capitalize).new(*args)
    #   end

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
  ActiveRecord::Migration.prepend RailsAsyncMigrations::Mutators
end