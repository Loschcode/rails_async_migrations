module RailsAsyncMigrations
  module Mutators
    class TriggerCallback < Base
      attr_reader :instance, :method_name

      def initialize(instance, method_name)
        @instance = instance
        @method_name = method_name
      end

      # TODO : all the logic of redis / sidekiq should be made in here
      # this method can be called multiple times (we should see what manages this actually)
      # if you use up down and change it'll be called 3 times for example
      def perform
        puts "FROM GEM: #{direction}"
        enqueue_asynchronous
      end

      private

      def enqueue_asynchronous
        # AsyncSchemaMigration.create!(
        #   version: current_migration,
        #   state: 'created'
        # )
      end

      # def catch_direction
      #   migration_class
      # end
    end
  end
end
