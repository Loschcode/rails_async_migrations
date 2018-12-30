# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class FireMigrationWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform(async_schema_migration_id)
        migration = AsyncSchemaMigration.find(async_schema_migration_id)
        return if migration.state == 'done'

        migration.update! state: 'processing'
        run_migration_with migration
        migration.update! state: 'done'
        Workers::CheckQueueWorker.perform_async
      end

      def run_migration_with(migration)
        Migration::Run.new(migration.direction, migration.version).perform
      rescue Exception => exception
        migration.update! state: 'failed'
        raise Exception, "#{exception}"
      end
    end
  end
end