# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    class FireMigrationWorker
      include Sidekiq::Worker

      sidekiq_options queue: :default

      def perform(async_schema_migration_id)
        Migration::FireMigration.new(
          AsyncSchemaMigration.find(async_schema_migration_id)
        ).perform
      end
    end
  end
end