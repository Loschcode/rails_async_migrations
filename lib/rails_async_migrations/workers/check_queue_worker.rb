# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class CheckQueueWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform
        Tracer.new.verbose 'Check queue has been triggered'

        if failed_migration
          Tracer.new.verbose 'Failing migration blocking the queue, cancelling check'
          return
        end

        if pending_migration || processing_migration
          Tracer.new.verbose 'Another migration under progress, cancelling check'
          return
        end

        unless next_migration
          Tracer.new.verbose 'No migration in queue, cancelling check'
          return
        end

        Tracer.new.verbose "Migration `#{next_migration.id}` will now be processed"
        next_migration.update state: 'pending'
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