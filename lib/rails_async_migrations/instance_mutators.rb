require 'rails_async_migrations/mutators/base'
require 'rails_async_migrations/mutators/turn_async'
require 'rails_async_migrations/mutators/trigger_callback'

module RailsAsyncMigrations
  module InstanceMutators
    def trigger_callback(method)
      Mutators::TriggerCallback.new(self, method).perform
    end
  end
end