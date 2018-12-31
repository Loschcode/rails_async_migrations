# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class CheckQueueWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform
        if failed_migration
          puts "there is a failing migration, we cannot run further"
          return
        end

        if pending_migration || processing_migration
          puts "already a pending migration, we exit"
          return
        end

        unless next_migration
          puts "no migration in queue"
          return
        end

        next_migration.update state: 'pending'
        puts "next_migration put in queue as pending #{next_migration.id}"
        RailsAsyncMigrations::Workers::FireMigrationWorker.perform_async(next_migration.id)
      end

      def next_migration
        created_migration
      end

      def processing_migration
        @processing_migration ||= AsyncSchemaMigration.processing.first
      end

      def pending_migration
        @pending_migration ||= AsyncSchemaMigration.pending.first
      end

      def created_migration
        @created_migration ||= AsyncSchemaMigration.created.first
      end

      def failed_migration
        @failed_migration ||= AsyncSchemaMigration.failed.first
      end
    end
  end
end