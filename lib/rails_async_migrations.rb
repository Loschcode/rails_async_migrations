require 'active_support'
require 'rails_async_migrations/version'
require 'rails_async_migrations/migration'
require 'rails_async_migrations/locker'
# require 'rails_async_migrations/models/async_schema_migration'

module RailsAsyncMigrations
  class Error < StandardError; end
  # Your code goes here...
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Migration.prepend(RailsAsyncMigrations::Migration)
end
