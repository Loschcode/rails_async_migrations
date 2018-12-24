# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class FireMigrationWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform(async_schema_migration_id)
        migration = AsyncSchemaMigration.find(async_schema_migration_id)
        migration.update state: 'processing'
        run_migration_with migration
        migration.update state: 'done'
        CheckQueueWorker.perform_async
      end

      def run_migration_with(migration)
        Migration::Run.new(migration.direction, migration.migration).perform
      rescue Exception => exception
        migration.update state: 'failed'
      ensure
        raise Exception, exception
      end
    end
  end
end