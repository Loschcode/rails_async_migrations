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
        enqueue_asynchronous
        fire_queue if last_migration?
      end

      private

      def enqueue_asynchronous
        AsyncSchemaMigration.create!(
          version: current_migration,
          direction: direction,
          state: 'created'
        )
      end

      def fire_queue
        # TODO : here we should launch the "central" worker which will fire the queue
      end

      def last_migration?
        # TODO : do this shit
      end

      def direction
        if instance.reverting?
          :down
        else
          :up
        end
      end

      #  Migrator.new(:up, selected_migrations, target_version).migrate
      # TODO : check migration_context.current_version
      def current_migration
        pending_migrations.first
      end

      # TODO this works only when you go forward not backward
      def pending_migrations
        migration_context.migrations.map(&:version) - migration_context.get_all_versions
      end

      def migration_context
        connection.migration_context
      end

      def connection
        # NOTE: seems at it was ActiveRecord::Migrator
        # in anterior versions
        @connection || ActiveRecord::Base.connection
      end
    end
  end
end
