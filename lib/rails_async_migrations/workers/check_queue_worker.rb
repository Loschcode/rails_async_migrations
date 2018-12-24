# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class CheckQueueWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform
        return unless next_migration
        next_migration.update state: 'pending'
        FireMigrationWorker.perform_async(next_migration.id)
      end

      def next_migration
        @next_migration ||= AsyncSchemaMigration.where(
          state: 'created'
        ).order(
          version: :asc
        ).first
      end
    end
  end
end