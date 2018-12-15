require 'rails_async_migrations/mutators/base'
require 'rails_async_migrations/mutators/turn_async'
require 'rails_async_migrations/mutators/trigger_callback'

# this is the entry point of the gem as it adds methods to the current migration class
# the `self` represents the class being ran so we have to be careful as not to conflict
# with the original ActiveRecord names
module RailsAsyncMigrations
  module Mutators
    private

    def turn_async
      TurnAsync.new(self).perform
    end

    # # the following methods are internal mechanics
    # # do not overwrite those methods if you don't know
    # # exactly what you're doing

    # def async_overwrite(method)
    #   AsyncOverwrite.new(self, method).perform
    # end

    # def async_callback(method)
    #   AsyncCallback.new(self, method).perform
    # end
  end
end