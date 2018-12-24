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
        @next_migration ||= AsyncSchemaMigration.find_by(
          state: 'created',
          version: active_record.current_version,
          direction: active_record.current_direction
        )
      end

      def active_record
        @active_record ||= Adapters::ActiveRecord.new
      end
    end
  end
end