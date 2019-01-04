require 'rails_async_migrations/mutators/base'
require 'rails_async_migrations/mutators/turn_async'
require 'rails_async_migrations/mutators/trigger_callback'

# this is the entry point of the gem as it adds methods to the current migration class
# the `self` represents the class being ran so we have to be careful as not to conflict
# with the original ActiveRecord names
module RailsAsyncMigrations
  module ClassMutators
    def turn_async
      Mutators::TurnAsync.new(self).perform
    end
  end
end

    # def self.descendants
    #   ObjectSpace.each_object(Class).select do
    #     |current| current < self
    #   end
    # end
      # descendants = self.class.descendants
      # descendants.delete_at descendants.index(ActiveRecord::Migration::Current)
      # real_self = descendants.last

      # puts "REAL SELF IS #{real_self}"
      # 