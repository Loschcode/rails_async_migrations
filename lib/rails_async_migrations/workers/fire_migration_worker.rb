# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class FireMigrationWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform(async_schema_migration_id)
        migration = AsyncSchemaMigration.find(async_schema_migration_id)
        migration.update state: 'processing'
        # NOTE : handle failed on crash of this part
        Migration::Run.new(migration.direction, migration.migration).perform
        migration.update state: 'done'
        CheckQueueWorker.perform_async
      end
    end
  end
end