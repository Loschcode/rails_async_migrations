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
        enqueue_asynchronous unless already_enqueued?
        fire_queue
        puts "callback perform done"
      end

      private

      def enqueue_asynchronous
        puts "CURRENT #{current_migration_version}"
        AsyncSchemaMigration.create!(
          version: current_migration_version,
          direction: direction,
          state: 'created'
        )
      end

      def already_enqueued?
        AsyncSchemaMigration.find_by(
          version: current_migration_version,
          direction: direction
        )
      end

      #  Migrator.new(:up, selected_migrations, target_version).migrate
       # TODO : here we should launch the "central" worker which will fire the queue
       # instead of directly firing the queue
      def fire_queue
        puts "we fire queue"
        migration = migration_from current_migration_version
        run_migration_for direction, migration
        puts "we finished to fire the queue"
      end

      # we run the migration ignoring the
      # turn_async system
      def run_migration_for(direction, migration)
        Migration::Run.new(direction, migration).perform
      end

      def direction
        if instance.reverting?
          :down
        else
          :up
        end
      end

      def migration_from(version)
        migration_context.migrations.find do |migration|
          migration.version == version
        end
      end

      def current_migration_version
        if direction == :down
          migration_context.current_version
        elsif direction == :up
          pending_migrations.first
        end
      end

      def pending_migrations
        achieved_migrations - all_migrations
      end

      def achieved_migrations
        migration_context.migrations.collect(&:version)
      end

      def all_migrations
        migration_context.get_all_versions
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
